![Coverage](app/coverage/coverage_badge.svg) [![Codemagic build status](https://api.codemagic.io/apps/5e2cc389b9213d44afe0ca6b/5e2cc389b9213d44afe0ca6a/status_badge.svg)](https://codemagic.io/apps/5e2cc389b9213d44afe0ca6b/5e2cc389b9213d44afe0ca6a/latest_build)
# Trare

Trare is a social network application for connecting travellers who want to do activities with other people (have a drink, go hiking, play a board game, etc).


## Where are we now?
- [x] User account : sign in, sign out, edit profile, delete profile, visualization
- [x] Explore activities
- [x] View an activity
- [x] Add new activities

<table style="border: none;">
<tr><td>

![](documents/src/screenR2.5.jpg)
</td><td>

![](documents/src/screenR2.4.jpg)</td>

<td>

![](documents/src/screenR2.3.jpg)</td></tr>
<tr><td>

![](documents/src/screenR2.6.jpg)
</td><td>

![](documents/src/screenR2.2.jpg)</td>

<td>

![](documents/src/screenR2.1.jpg)</td></tr>
<tr><td>

![](documents/src/screen_5.3.jpg)
</td><td>

![](documents/src/screen_5.2.jpg)</td>

<td>

![](documents/src/screenR2.7.jpg)</td>
</td></tr>
<tr><td>

![](documents/src/screenR2.8.jpg)</td><td>

</td>

<td>

</td>
</td></tr>
</table>
</div>

## What's next ?
![](documents/src/use_case.png)
- [ ] Add photo to the user profile
- [ ] System for connecting users (activity chats, "I'm interested" button)
- [ ] Ability to change the activity search parameters (radius, position)

## How to contribute ?
- Make sure to read the contributing guide: [`CONTIBUTING.md`](CONTRIBUTING.md)
- Assign yourself an issue or create a new one. Each question of the current sprint is listed in the corresponding [Github Project](https://github.com/Romain-Guillot/Trare/projects) (Kanban board)
- Move your issue in the **WIP** column and resolve your issue
- Close the issue (it will automatically move the issue in the Done column)

**Preferably resolve one issue per commit.** It's easier for code review.

## How to install it ?
There are three ways to install and use the project, either you just want to download the application to your phone from the play store (simpler), or you want to download the application from the Github releases, or you want to build the application from the source code (more complicated).

We do not yet support iOS because we don't have a Mac or an iPhone to build and test the application.

### 1. Download the application on the Google Play (Android)

⚠️ **Ask us to be part of the internal testers.**

<div style="width:250px">
<a href='https://play.google.com/store/apps/details?id=com.trare.app&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>
</div>


### 2. Download the application from the Github releases (Android)

Go to [the latest releases](https://github.com/Romain-Guillot/Trare/releases) and download apks (`.apks`) file. Then follow these instructions :
1. If you haven’t done so already, download bundletool from the [GitHub repository](https://github.com/google/bundletool/releases/tag/0.13.3)
2. [Deploy the APKs to connected devices](https://developer.android.com/studio/command-line/bundletool#deploy_with_bundletool).

> Android Package (APK)[1] is the package file format used by the Android operating system for distribution and installation of mobile apps, mobile games and middleware.
> **Wikipedia**

**For this, you will need to have previously authorized the installation of the application from unknown sources - [tutorial](https://www.androidauthority.com/how-to-install-apks-31494/)**


### 3. Build the application on your computer
Build the application directly from the source code is more complicated because to use some services (Firebase, Maps, Facebook Auth) the application HAS to be signed with an autorized certificate (that you don't have)

1. First, you need to set-up your environment
    1. [Install Flutter](https://flutter.dev/docs/get-started/install)
    1. [Set up an editor](https://flutter.dev/docs/get-started/editor?tab=vscode)
1. Download the code source (clone or download directly the archive file)
1. Send us a request with the [SHA1 signature of your PC](https://developers.google.com/android/guides/client-auth) for us to add it as a trust signature.

You can also set up your own services (Firebase, Google Maps and Facebook Auth). In this case you'll need to
1. modify the `app > android > app > google_services.json` file to include your Google services (with the following services to enable : Firestore, Google Authentication, Facebook Authentication, Firebase Storage)
2. Update the Google Map SQK API Key in the `app > android > app > src > main > AndroidManifest.xml` with your own key
3. Finally, update the keys in `app > android > app > src > main > res > values > string.xml` for the Facebook authentication with your own keys

## How to use it ?

The application can be used like many other applications. When you open it you will have to log in to access the different features.








<!-- eof -->
