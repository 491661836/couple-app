# 💕 我们的小窝 - 部署与使用指南

零成本情侣双人安卓APP，全程免费，无需服务器。

---

## 📁 项目文件说明

```
couple-app/
├── index.html          # 主程序（所有功能代码）
├── manifest.json       # PWA配置（打包APK必需）
├── sw.js               # Service Worker（离线缓存）
├── icon-192.png        # APP图标（192x192）
├── icon-512.png        # APP图标（512x512）
├── supabase-setup.sql  # 数据库建表脚本
└── README.md           # 本说明文档
```

---

## 🚀 部署步骤（共4步，约20分钟）

### 第1步：注册 Supabase 并建数据库

1. 打开 https://supabase.com ，点 **Start your project**，用 GitHub 或邮箱注册（免费）
2. 新建项目，项目名随便填（如 `couple-app`），区域选离你近的（如 `Southeast Asia`）
3. 设置数据库密码（记下来，后面可能用到）
4. 等待项目创建完成（约1-2分钟）
5. 左侧菜单点 **SQL Editor** → 点 **New query**
6. 打开本项目里的 `supabase-setup.sql`，复制全部内容，粘贴到 SQL Editor，点 **Run**
7. 看到 "Success. No rows returned" 就说明建表成功了

### 第2步：获取 Supabase 连接信息

1. 在 Supabase 项目里，左侧菜单点 **Settings**（齿轮图标）→ **API**
2. 复制 **Project URL**（形如 `https://xxxx.supabase.co`）
3. 复制 **anon public** 密钥（一长串字符串）
4. 打开本项目的 `index.html`，找到这两行（在文件靠上的位置）：
   ```js
   const SUPABASE_URL = 'https://你的项目.supabase.co';
   const SUPABASE_ANON_KEY = '你的anon-key';
   ```
5. 把上面两个值替换成你自己的，保存文件

### 第3步：部署到 Vercel（免费托管）

**方式A：用 Vercel CLI（推荐，简单）**
1. 打开 https://vercel.com ，用 GitHub 注册（免费）
2. 下载安装 Vercel CLI：在命令行运行 `npm i -g vercel`（需要先装 Node.js）
3. 进入项目目录：`cd couple-app`
4. 运行 `vercel`，按提示登录并部署
5. 部署完成后会给你一个网址（形如 `https://couple-app-xxxx.vercel.app`），记下来

**方式B：上传到 GitHub 再导入 Vercel**
1. 把整个 `couple-app` 文件夹上传到 GitHub 仓库
2. 在 Vercel 点 **Add New** → **Project** → 导入刚才的仓库
3. 框架预设选 **Other**，点 **Deploy**
4. 等待部署完成，复制生成的网址

> 部署完成后，用手机浏览器打开这个网址，确认能正常显示登录页，就说明成功了。

### 第4步：打包成安卓 APK

1. 打开 https://www.pwabuilder.com （微软出品，免费）
2. 在输入框里粘贴你第3步得到的 Vercel 网址，点 **Start**
3. 系统会检测你的 PWA，等待检测完成
4. 点 **Package for stores**
5. 在 **Android** 那一栏，点 **Download**（下载的是一个 zip 包，里面包含 .apk/.aab 文件）
6. 把 zip 解压，找到 `.apk` 文件，传到安卓手机上安装
7. 手机安装时如果提示「未知来源应用」，去设置里允许安装即可

> 苹果手机无法安装此 APK，直接用 Safari 打开网址，然后点「添加到主屏幕」，体验和APP一样。

---

## 📱 使用说明

### 首次使用
1. 打开APP，输入双人密码（默认密码：`love123`）
2. 选择你的身份（A 或 B，两个人选不同的）
3. 点「进入小窝」

### 功能说明
- **首页**：恋爱计时 + 对方在线状态 + 对方最近设备快照
- **留言**：双向悄悄话，实时同步
- **心愿**：共同心愿清单，可标记完成
- **我的**：修改纪念日/密码、查看本机状态、手动上报快照、退出登录

### 重要操作
- **修改密码**：进入「我的」页面，在双人密码输入框填新密码，点保存设置
- **修改纪念日**：进入「我的」页面，选择日期，点保存设置
- **手动上报状态**：进入「我的」页面，点「手动上报状态快照」
- **查看对方位置**：在首页点「位置」那栏，会弹出经纬度，可跳转地图

---

## ⚠️ 已知限制（系统层面，无法绕过）

1. **无系统推送**：对方必须APP在前台打开，才能看到上线提示；锁屏/后台收不到通知
2. **退出快照可能丢失**：快速划掉APP进程时，有小概率来不及上传状态快照
3. **定位需授权**：首次使用需手动允许定位权限，后续自动获取；不能后台静默定位
4. **无法读取其他APP使用时间**：只能统计本APP自身运行时长，这是安卓/iOS系统限制
5. **免费平台休眠**：Vercel 免费版长时间无人访问会休眠，首次打开可能慢2-3秒
6. **仅安卓可装APK**：苹果手机只能用网页添加到桌面

---

## 🔧 常见问题

**Q: 打开APP显示空白或报错？**
A: 检查 `index.html` 里的 Supabase URL 和 anon key 是否填对了，注意不要有多余空格。

**Q: 留言/状态不同步？**
A: 检查网络连接，确认 Supabase 数据库建表成功（去 Supabase → Table Editor 看有没有5张表）。

**Q: 定位一直获取失败？**
A: 确认手机开启了定位服务，APP有定位权限；部分手机需要在设置里手动授权。

**Q: 想换密码但忘了旧密码？**
A: 去 Supabase → Table Editor → config 表，找到 key 为 password 的行，直接修改 value 即可。

**Q: PWABuilder 打包失败？**
A: 确认 Vercel 网址能正常访问，manifest.json 和图标都在；可以先用 Chrome 打开网址，看地址栏有没有安装图标。

---

## 🎉 完成！

部署完成后，把 APK 发给另一半，两个人分别安装，选不同身份（A/B），输入相同密码，就可以开始使用了。

祝你们幸福 💕
