/* v854c: 바로 뜨게 — 화면(index)·설정은 저장본 먼저 보여 주고 뒤에서 새로 받아 둠, 게임 코드(game.js?v=버전)는 버전마다 한 번만 받음
   새 버전 배포 → sw.js 내용이 바뀜 → 브라우저가 새 서비스워커를 받아 새 화면·코드를 미리 저장 → 첫 화면에 있으면 한 번 새로고침 */
const VER='cedd2663d0',CACHE='yagu-'+VER;
const SHELL=['./','manifest.webmanifest','config.js','game.js?v='+VER,'icons/icon-192.png','icons/icon-512.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(SHELL.map(u=>new Request(u,{cache:'reload'})))).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE&&/^yagu-/.test(k)).map(k=>caches.delete(k)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',e=>{const r=e.request;if(r.method!=='GET')return;const u=new URL(r.url);if(u.origin!==location.origin)return;
  if(/^\/mig(\.html)?$/.test(u.pathname))return; /* v857t 커리어 옮기기 화면은 서비스워커가 건드리지 않음(주소 뒤 데이터가 저장본에 남지 않게) */
  const root=new URL('./',self.registration.scope).pathname,isRoot=r.mode==='navigate'&&(u.pathname===root||u.pathname===root+'index.html');
  if(isRoot){const net=fetch(r).then(res=>{if(res.ok&&!res.redirected){const cp=res.clone();return caches.open(CACHE).then(c=>c.put('./',cp)).then(()=>res)}return res});
    e.waitUntil(net.then(()=>{},()=>{}));e.respondWith(caches.open(CACHE).then(c=>c.match('./')).then(hit=>hit||net));return}
  if(/\/game\.js$/.test(u.pathname)){e.respondWith(caches.open(CACHE).then(c=>c.match(r).then(hit=>hit||fetch(r).then(res=>{if(res.ok)c.put(r,res.clone());return res}))));return}
  if(r.mode==='navigate'){e.respondWith(fetch(r).then(res=>{if(res.ok&&!res.redirected){const cp=res.clone();caches.open(CACHE).then(c=>c.put(r,cp))}return res}).catch(()=>caches.match(r).then(h=>h||caches.match('./'))));return}
  const net=fetch(r).then(res=>{if(res.ok&&!res.redirected){const cp=res.clone();caches.open(CACHE).then(c=>c.put(r,cp))}return res});
  e.waitUntil(net.then(()=>{},()=>{}));e.respondWith(caches.match(r).then(hit=>hit||net))});
