// Service Worker script for sqflite_common_ffi_web
// Registers a virtual filesystem-based SQLite worker

self.addEventListener('install', function (event) {
    self.skipWaiting();
});

self.addEventListener('activate', function (event) {
    event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
    // Pass through fetch requests
    event.respondWith(fetch(event.request));
});
