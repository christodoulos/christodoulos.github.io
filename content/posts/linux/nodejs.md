---
date: 2023-05-19
title: Node.js
tags: [linux, nodejs]
---

This is my personal notepad for Node.js related technical information. Proceed at your own risk.

## Start an application automatically with PM2

To start a Node.js application automatically with PM2 upon boot or reboot of the system, you need to use the PM2 Startup feature.

The PM2 Startup command is designed to generate and configure a startup script to launch PM2 and its managed processes on server boots.

Here are the steps you need to follow:

First, you need to generate a startup script with PM2. To do this, open your terminal and type:

```bash
pm2 startup
```

This command will generate a command that you need to run. The command will look something like this:

```bash
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u yourusername --hp /home/yourusername
```

Please replace yourusername with the name of the user that runs the PM2 process.

You need to run this command in your terminal to set up the PM2 service.

You should now have PM2 set to run at startup, but PM2 doesn't know which processes it should be managing. To tell PM2 to manage the current processes you have running in case of a reboot or server shutdown, use the `pm2 save` command.

First, make sure your application is running by executing:

```bash
pm2 start /path/to/your/app.js
```

Then, execute the pm2 save command:

```bash
pm2 save
```

This command will save all current running PM2 processes. PM2 will now remember all the current running processes and restart them on reboot.

You can verify the list of processes that PM2 will restart on boot by running the pm2 list or `pm2 show [app-name]` command:

```bash
pm2 list
```

Now your application should start automatically when the virtual machine reboots. Remember to replace `/path/to/your/app.js` with the actual path to your JavaScript application. Also, make sure to start your application with the same user you ran the PM2 startup command, otherwise PM2 might not be able to access or run your application.
