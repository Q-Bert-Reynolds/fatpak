#!/usr/bin/env python3
"""Exercise the host's public MCP schema, registry and real stdio dispatch."""
from pathlib import Path
import json
import os
import selectors
import shutil
import tempfile
import subprocess
import sys
root=Path(__file__).resolve().parents[2]
source=Path(sys.argv[1]).resolve()
runtime=tempfile.TemporaryDirectory(prefix='host-mcp-',dir=root/'build/sgb')
exe=Path(runtime.name)/'gearboy'
shutil.copy2(source,exe)
log=(root/'build/sgb/host-mcp.stderr').open('w')
env=dict(os.environ,SDL_AUDIODRIVER='dummy')
process=subprocess.Popen([str(exe),'--headless','--mcp-stdio','--portable'],stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE,stderr=log,text=True,bufsize=1,env=env)
selector=selectors.DefaultSelector(); selector.register(process.stdout,selectors.EVENT_READ)
request_id=0
def call(method,params):
    global request_id
    request_id+=1
    process.stdin.write(json.dumps(dict(jsonrpc='2.0',id=request_id,method=method,params=params))+'\n'); process.stdin.flush()
    while True:
        if not selector.select(20): raise AssertionError('MCP response timeout; see build/sgb/host-mcp.stderr')
        line=process.stdout.readline()
        if not line: raise AssertionError('MCP exited: '+str(process.poll()))
        data=json.loads(line)
        if data.get('id')==request_id:
            assert 'error' not in data,data
            return data['result']
def host(**args):
    result=call('tools/call',dict(name='fatpak_sgb_host',arguments=args))
    assert not result.get('isError'),result
    return json.loads(result['content'][0]['text'])
try:
    call('initialize',dict(protocolVersion='2024-11-05',capabilities={},clientInfo=dict(name='fatpak-host-test',version='1')))
    tools=call('tools/list',{})['tools']; assert any(t['name']=='fatpak_sgb_host' for t in tools)
    state=host(action='configure',profile='bench'); assert state['ok'] and not state['active']
    state=host(action='replay',path=str(root/'build/sgb/bench.fph')); assert state['ok'] and state['good']==66 and state['upload_bytes']==4096
    assert host(action='verify_upload',path=str(root/'build/sgb/bench.SGB.DAT'))['ok']
    assert not host(action='key',key=65)['ok'] # Bench has its own isolated mailbox.
    state=host(action='replay',path='/tmp/gearboy-fatpak-v1.fph'); assert state['ok'] and state['active']
    state=host(action='snes_press',button='down'); assert state['ok'] and state['mailbox'][1:]==[1,0x83,0]
    assert host(action='mouse_click',row=4,x=120,buttons=1)['ok']
    assert host(action='image',path=str(root/'build/sgb/mcp-reference.ppm'))['ok']
    assert (root/'build/sgb/mcp-reference.ppm').read_bytes().startswith(b'P6\n256 224\n255\n')
    state=host(action='configure',profile='disabled'); assert state['ok'] and not state['active']
    print('Gearboy MCP host schema/dispatch/replay/upload/input/image checks passed')
finally:
    process.terminate()
    try: process.wait(5)
    except subprocess.TimeoutExpired: process.kill(); process.wait()
    log.close()
    runtime.cleanup()
