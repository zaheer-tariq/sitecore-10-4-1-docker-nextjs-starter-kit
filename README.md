# Sitecore 10.4.1 Docker Next.js Basic Company Starter Kit

This is a fully automated, updated version of [Sitecore Docker Helix Basic Company with Next.js](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-nextjs) starter kit that is designed to run Sitecore on Docker Containers, the Sitecore Next.js SDK, and Sitecore Content Serialization.

## Don't Like Reading? -> Get to action

1- Make sure IIS is stopped, you can run this in Windows PowerShell after running it as Administrator
   ```
   iisreset /stop
   ```

2- Make sure Virtualization is enabled, Hyper-V and Containers are installed, you can also install Hyper-V and Containers using this command in Windows PowerShell after running it as Administrator
   ```
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All, Containers -All -NoRestart
   ```   
   
3- Install the following Software
- [Nodejs 22.x](https://nodejs.org/en/download)
- [.NET 10.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/10.0) & [.NET 8.0 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-8.0.22-windows-x64-installer?cid=getdotnetcore)
- [Docker for Windows](https://desktop.docker.com/win/main/amd64/149282/Docker%20Desktop%20Installer.exe), with Windows Containers enabled. This is tested with Docker for Windows Version 4.30.0 (149282)
- [Visual Studio >= 2019](https://visualstudio.microsoft.com/downloads/) & [Visual Studio Code](https://visualstudio.microsoft.com/downloads/) Optional for development later.

4- Open Windows PowerShell as Administrator and run this command, make sure license file exists at the path below
   ```ps1
   .\init.ps1 -InitEnv -LicenseXmlPath "C:\Projects\license.xml" -AdminPassword "b"
   ```

Once the script is completed it will automatically open Sitecore CM and Website in browser. Enjoy!

* Sitecore Content Management: https://cm.basiccompany.localhost/sitecore
* Sitecore Identity Server: https://id.basiccompany.localhost
* Basic Company site: https://www.basiccompany.localhost


## What's Included

- This solution implements Sitecore Helix conventions for the back-end (platform)
solution architecture. You can find more details on Helix Architecture at [Sitecore Helix](https://helix.sitecore.net/) and the
[Sitecore Helix Examples](https://sitecore.github.io/Helix.Examples/).

- A `docker-compose` environment for each Sitecore topology (XPO, XP1, XM1, XM0)
  with an ASP.NET Core rendering host. However, the default topology is XM0

  > The containers structure is organized by specific topology environment (see `run\sitecore-xp0`, `run\sitecore-xp1`, `run\sitecore-xm0`, `run\sitecore-xm1`).
  > The included `docker-compose.yml` is a stock environment from the Sitecore
  > Container Support Package. All changes/additions for this solution are included
  > in the `docker-compose.override.yml`.

- Scripted invocation of `jss create` and `jss deploy` to initialize a Next.js application.
- Sitecore Content Serialization configuration.
- An MSBuild project for deploying configuration and code into the Sitecore Content Management role. (see `src\platform`).

## Using the Solution
- You can run the solution by running `.\up.ps1` in Windows PowerShell after running it as Administrator
- You can stop the solution by running `.\down.ps1` in Windows PowerShell after running it as Administrator
- A Visual Studio / MSBuild publish of the `Platform` project will update the running `cm` service.
- The running `rendering` service uses `next dev` against the mounted Next.js application, and will recompile automatically for any changes you make.
- You can also run the Next.js application directly using `npm` commands within `src\rendering`.
- Debugging of the Next.js application is possible by using the `start:connected` or `start` scripts from the Next.js `package.json`, and the pre-configured _Attach to Process_ VS Code launch configuration.
- Review README's found in the projects and throughout the solution for additional information.
