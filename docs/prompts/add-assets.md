# Prompt — إضافة أصول (Fonts / Images / Icons) للمشروع

> **إزاي تستخدمه:** ده Prompt عام تقدر تستخدمه في أي وقت — أي مرة حد في الفريق يحمّل تصدير جديد من Figma على الـ Downloads (صور، أيقونات SVG). حط `CLAUDE.md` في الـ root، الصق الـ Prompt، وقوله المصدر والوجهة.
>
> **ده بالظبط اللي اتعمل النهارده** على `movies_app` — Roboto + Inter (خطين، مش خط واحد) + 22 ملف من الـ Downloads. القسم الأخير في الملف ده فيه سجل بكل حاجة اتعملت، عشان أي حد في الفريق يعرف يتحقق منها أو يكررها.
>
> **القواعد المرجعية** موجودة في قسم `## 🖼️ Assets` في `CLAUDE.md` — لو اختلف حاجة هنا عن هناك، `CLAUDE.md` هو الأصح.

---

## ⬇️ الـ Prompt (انسخ من هنا)

You are wiring newly-downloaded design assets (fonts, images, SVG icons) into a Flutter project. Read `CLAUDE.md` first and follow its design tokens. This task touches `pubspec.yaml`, `assets/`, and one constants file — nothing else.

### 1. Fonts

If the project needs a Google Font and only some/none of its weights exist locally:

1. Prefer the **variable font** file over separate static weight files — modern Google Fonts ship most families as one variable `.ttf` covering the full weight axis (e.g. `Inter[opsz,wght].ttf`). One file, register it once:
   ```yaml
   fonts:
     - family: Inter
       fonts:
         - asset: assets/fonts/Inter-Variable.ttf
   ```
   Every `FontWeight` used in `app_text_styles.dart` (400/500/600/700/…) resolves correctly from this single file — do not download four separate static files unless the variable file genuinely does not exist for that family.
2. Save the file as `assets/fonts/<Family>-Variable.ttf`.
3. Do not touch any other part of `pubspec.yaml` — only the `fonts:` block.

### 2. Sorting a Downloads folder into the project

You will be pointed at a local folder (typically the user's Downloads) containing a mix of files. Before copying anything:

1. **List it and classify every file** — do not bulk-copy. For each file decide: *belongs to this project* / *belongs to a different project* / *not an asset* (a `.pdf`, `.pptx`, `.docx`, `desktop.ini`, lock files, personal documents).
2. When two projects share a filename (e.g. `Search.svg`, `caret-right.svg` also exist in another project's `assets/`), use file **modified time** to cluster them — files exported in the same Figma session land within seconds of each other. A cluster whose names already exist in another project's asset folder belongs to that other project; skip it.
3. **Never move or touch anything that isn't an image or vector asset** for this task — especially personal documents (bank statements, IDs, anything with a person's name). If unsure whether a file is personal, leave it in place and say so instead of guessing.
4. **Never delete the source files** in Downloads. Copy only.

### 3. Renaming

Source filenames from stock sites or Figma exports are not usable as-is (`xl_848228_477d9240 1.png`, `🦆 icon _google_.svg`, spaces, emoji, parentheses). Rename every file you copy to `snake_case` that describes **what it is**, not where it came from:

- A set of numbered variants (e.g. an avatar picker) → `avatar_01.png` … `avatar_NN.png`, renumbered sequentially even if the source names have gaps.
- A one-off illustration or icon → name it after its role: `illustration_forgot_password.png`, `icon_google.svg`.
- If you cannot confidently tell what a generic icon (`Vector.svg`) is for, keep a neutral but distinct name (`icon_vector_1.svg`) rather than guessing a wrong semantic name — a wrong name that ends up wired into code is worse than a neutral one. Flag it in your summary for a human to confirm and rename.

Route by type: images → `assets/images/`, vector icons → `assets/icons/`, fonts → `assets/fonts/`.

### 4. Compressing oversized images

Check every copied image's dimensions and file size (`identify` / PIL). A raw stock photo or hero export is often 1500px+ wide and several megabytes — that bloats the app for no visual gain, since it will only ever render at a few hundred logical pixels.

1. Keep a full-resolution copy in `assets/images/original/` (a subfolder — Flutter's `assets: - assets/images/` declaration bundles only the top level of a listed directory, not subdirectories, so `original/` is never shipped).
2. In the top-level `assets/images/`, resize the bundled copy to roughly **2–3× its largest real on-screen size** and re-encode:
   - Photographic content (posters, photos) with no transparency need → convert to **JPEG, quality ~80–85**. This is typically a 30–60× size reduction with no visible quality loss at mobile card sizes.
   - Illustrations/icons that need transparency → keep **PNG**, just resize.
3. Never leave a multi-megabyte file in the bundled `assets/images/` directory.

### 5. `AppAssets` constants

Every path lands in `lib/core/constants/app_assets.dart` as a named `static const String` (or `static const List<String>` for a numbered set like avatars or mock posters). No feature file ever writes an `'assets/...'` string literal — it imports `AppAssets` and reads a constant. If the file doesn't exist yet, create it; if it exists, add to it without removing existing entries.

### 6. `pubspec.yaml` assets block

Make sure an `assets:` list exists under the top-level `flutter:` key covering every folder you added files to (typically `assets/images/` and `assets/icons/`, not `assets/fonts/` — that only needs the `fonts:` block). Do not list individual files one by one when a directory listing covers them; do not list `assets/images/original/`.

### 7. Report

When done, list: every file added (source name → new path), every file skipped and why, every compression you applied with before/after size, and anything you renamed a best-guess rather than a confident name.

## ⬆️ (نهاية الـ Prompt)

---

## سجل التنفيذ — 2 سبتمبر 2026 (`movies_app`)

**الخط — خطين، مش خط واحد:**

المحاولة الأولى كانت Inter بس، بعدين لوحة Dev Mode في Figma أكّدت إن **Roboto** هو خط أغلب الشاشات (Login/Register/Forget Password/Search/Browse/Profile/Movie Details/Update Profile) — شلنا Inter واستبدلناه بـ Roboto بالكامل. لكن ده كان غلط: التقسيم بين الخطين في الـ Figma **متعمّد**، مش خبط — Inter محصور فعلياً في 3 Styles بالأونبوردنج بس (`displayLarge`, `labelLarge`, `bodyLarge`). رجّعنا Inter جنب Roboto.

النتيجة النهائية: الاتنين مسجّلين في `pubspec.yaml` كـ Variable fonts منفصلة —

```yaml
fonts:
  - family: Roboto
    fonts:
      - asset: assets/fonts/Roboto-Variable.ttf
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter-Variable.ttf
```

و`AppTextStyles._style()` بياخد `family` كـ parameter اختياري (افتراضي Roboto)، فكل Style بيحدد خطه بنفسه بدل ثابت واحد للتطبيق كله. تفاصيل مين بيستخدم إيه في قسم Typography بتاع `CLAUDE.md`.

**من الداونلودز (`C:\Users\abdel\Downloads`) → `movies_app`:**

| المصدر | الوجهة | ملاحظة |
|---|---|---|
| `a1.png` … `AAA.png`, `gamer (1).png`, `gamer (1)_.png` | `assets/images/avatar_01.png` … `avatar_09.png` | 9 أفاتار لشاشة Pick Avatar |
| `1917_..._1.png` | `assets/images/onboarding_collage_6.jpg` | 5.2MB → 99KB (resize 600px + JPG q82) |
| `The Godfather 1.png` | `assets/images/onboarding_collage_3.jpg` | 5.7MB → 114KB |
| `xl_848228_477d9240 1.png` | `assets/images/onboarding_collage_2.jpg` | 5.6MB → 126KB |
| `xl_9419884_887ed6c7 1.png` | `assets/images/onboarding_collage_5.jpg` | 5.5MB → 110KB |
| `xl_bad-boys-ride-or-die-movie-poster_591dcde0 1.png` | `assets/images/onboarding_collage_4.jpg` | 6.9MB → 142KB |
| `Movies Posters.png` | `assets/images/onboarding_collage_1.jpg` | 7.9MB → 210KB (كولاج البوسترات المائل) |
| `Group 44.png` | `assets/images/app_logo.png` | لوجو التطبيق |
| `Mask group.png` | `assets/images/route_logo.png` | لوجو Route للـ Splash |
| `Forgot password-bro 1.png` | `assets/images/forgot_password.png` | إليستريشن Reset Password |
| `🦆 icon _google_.svg` | `assets/icons/icon_google.svg` | — |
| `🦆 icon _Identification_.svg` | `assets/icons/icon_person.svg` | — |
| `Vector.svg` | `assets/icons/icon_phone.svg` | Phone Icon (كان `icon_vector_1` مؤقتاً) |
| `Vector_.svg` | `assets/icons/icon_email.svg` | Email Icon (كان `icon_vector_2` مؤقتاً) |

> **إعادة الترتيب النهائية (2 سبتمبر مساءً)** — الجدول فوق بيوري الأسماء النهائية بعد التصحيح:
>
> - `icon_vector_1/2` → `icon_phone.svg` / `icon_email.svg` — و `AppAssets.iconPhone` / `iconEmail`.
> - لوجو التطبيق ولوجو Route كانوا اتسمّوا `onboarding_collage_1/2` بالغلط → `app_logo.png` / `route_logo.png` — و `AppAssets.appLogo` / `routeLogo` تحت قسم Branding.
> - البوسترات المفردة + كولاج البوسترات كلهم بقوا خلفيات OnBoarding: `onboarding_collage_1..6.jpg` — و `AppAssets.onboardingCollages` (List بـ 6). اتشالت ثوابت `mockPosters` / `posterSample*` / `moviesPostersCollage`.
> - `illustration_forgot_password.png` → `forgot_password.png` (الثابت `illustrationForgotPassword` فضل زي ما هو، المسار اتحدّث).
> - فولدر `assets/images/original/` (النسخ كاملة الدقة) اتمسح — مفيش مصدر أصلي محفوظ للصور دي بعد كده.
