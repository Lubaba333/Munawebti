importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBgdNIwI84iOILkm1cKwC6k6DEjZNnSfPI",
  authDomain: "munawebti.firebaseapp.com",
  projectId: "munawebti",
  storageBucket: "munawebti.firebasestorage.app",
  messagingSenderId: "67974807541",
  appId: "1:67974807541:web:fd6a66f86aa256dc7deabc",
});

const messaging = firebase.messaging();

// ✅ استقبال إشعار بالخلفية
messaging.onBackgroundMessage(function (payload) {
  console.log("📦 Background Message:", payload);

  const notificationTitle =
    payload.notification?.title || "New Notification";

  const notificationOptions = {
    body: payload.notification?.body || "",
    icon: "/icons/Icon-192.png",
  };

  self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});

// ✅ عند الضغط على الإشعار
self.addEventListener("notificationclick", function (event) {
  event.notification.close();

  event.waitUntil(
    clients.openWindow("/") // أو route معين
  );
});