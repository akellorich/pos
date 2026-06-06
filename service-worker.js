const CACHE_NAME = 'epos-cache-v1';
const ASSETS_TO_CACHE = [
  'index.html',
  'css/bootstrap.css',
  'css/all.css',
  'css/index.css',
  'css/alert.css',
  'images/logo.png',
  'js/jquery-2.2.4.js',
  'js/popper.js',
  'js/bootstrap.js',
  'js/alert.js',
  'js/functions.js',
  'js/index.js'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            return caches.delete(cache);
          }
        })
      );
    })
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) {
        return cachedResponse;
      }
      return fetch(event.request);
    })
  );
});
