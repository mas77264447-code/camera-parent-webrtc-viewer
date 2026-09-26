proot-distro login ubuntu
curl -X POST http://127.0.0.1:8080/camera/create
curl -X POST http://192.168.1.96:8080/camera/create
nano lib/services/camera_service.dart
cd /opt/camera_parent
mkdir -p lib/services
nano lib/services/camera_service.dart
ls lib/services
flutter analyze
proot-distro login ubuntu
cd /opt/camera_parent
nano lib/screens/home_screen.dart
cd /opt/camera_parent
mkdir -p lib/screens
ls lib.
proot-distro login ubuntu
pkg install git -y
git clone https://github.com/mas77264447-code/camera_parent.git
cd camera_parent
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <application
        android:label="camera_parent"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
            />

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>

        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />

    </application>

    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>

</manifest>
EOF

git add android/app/src/main/AndroidManifest.xml
git commit -m "Fix: add INTERNET permission"
git push
mkdir -p server
cd ~/camera_parent
cat > server/package.json << 'EOF'
{
  "name": "camera-parent-server",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.19.2"
  }
}
EOF

cat server/package.json
[200~mkdir -p server~
mkdir -p server
ls
cat > server/package.json << 'EOF'
{
  "name": "camera-parent-server",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.19.2"
  }
}
EOF

cat server/package.json
cat > server/index.js << 'EOF'
const express = require("express");
const app = express();

app.use(express.json());

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  res.header("Access-Control-Allow-Headers", "Content-Type");
  next();
});

app.post("/camera/create", (req, res) => {
  const sessionId = Date.now().toString();
  const baseUrl = `${req.protocol}://${req.get("host")}`;
  const childUrl = `${baseUrl}/camera/view?session=${sessionId}`;

  res.json({
    data: {
      child_url: childUrl,
    },
  });
});

app.get("/camera/view", (re
cat server/index.js
EOF

cat > server/index.js << 'EOF'
const express = require("express");
const app = express();

app.use(express.json());

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  res.header("Access-Control-Allow-Headers", "Content-Type");
  next();
});

app.post("/camera/create", (req, res) => {
  const sessionId = Date.now().toString();
  const baseUrl = `${req.protocol}://${req.get("host")}`;
  const childUrl = `${baseUrl}/camera/view?session=${sessionId}`;

  res.json({
    data: {
      child_url: childUrl,
    },
  });
});

app.get("/camera/view", (req, res) => {
  const session = req.query.session || "";
  res.send(`
    <html>
      <head><meta charset="utf-8"><title>Camera - Child</title></head>
      <body style="font-family: sans-serif; text-align:center; padding-top:50px;">
        <h2>صفحة الطفل</h2>
        <p>Session: ${session}</p>
        <p>قيد التطوير</p>
      </body>
    </html>
  `);
});

app.get("/", (req, res) => {
  res.send("Camera Parent server is running.");
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

cat server/index.js
cat > lib/services/camera_service.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;

class CameraService {

  static const String server =
      "https://camera-parent-server.onrender.com";

  static Future<String?> createCameraSession() async {

    final response = await http.post(
      Uri.parse("$server/camera/create"),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final childUrl =
          data["data"]["child_url"];

      return childUrl;
    }

    return null;
  }
}
EOF

cat lib/services/camera_service.dart
git add .
git commit -m "Add cloud backend server for Render deployment"
git push
