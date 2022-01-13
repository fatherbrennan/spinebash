# Spinebash

This is a Bash-built, dependency-free SPA framework which allows for a modular programming experience using HTML, CSS and JavaScript. Spinebash aims to be dependency-free and only utilises standard CLI tools.

Notable Utilised Commands

-   awk
-   sed
-   find
-   perl
-   truncate

## File Structure

**.config**

Spinebash configuration file to alter framework behaviour.

**Resources/**

Directory containing application resources.

**Resources/views/static/**

Parent directory of static content and views.

-   File paths are fixed
-   Content added to asset files will be static throughout application navigation (unless forced manipulation)

Child directories:

-   Head
    -   Static content inserted inside the &lt;head&gt; tag
-   Frame
    -   Content is wrapped inside a &lt;div class="frame"&gt; element
    -   Spinebash Bootstrap CSS - width: 100%, height: 29px
    -   Typical usage is for desktop applications through frameworks such as [Electron](https://www.electronjs.org/)
-   Nav
    -   Content is wrapped inside a &lt;div class="nav"&gt; element
    -   View is inserted between the Frame view and the dynamic content views
    -   (Hint) Reusable elements can be added to nav to be cross-viewable-content

**Resources/views/content/**

Directory containing dynamic views.

-   File paths are dynamic and can be changed
-   All views are added to the asset file (Public/index.html)
-   One dynamic view is displayed at a time (declared in routes)

**Resources/routes.sh**

Declare application routes.

**Public/**

Directory containing built asset files.

**Framework/**

Directory containing framework resources.

**set_alias.sh**

Temporary initialisation executable to add the `spine` alias used for the Spine CLI.

```sh
. ./set_alias.sh
```

Notes

-   File should be removed after initialisation
-   File requires executable permissions: `chmod 700 set_alias.sh`
-   Add `spine` alias to Bash and (if exists) Zsh

**spine**

Spine is the included command line interface used to interact with the Spinebash framework.

```sh
spine --help
```

```
spine
 Usage: spine <command> <extension>

commands

 start, dev
	build app assets in dev mode

 open
	open the app in the default web browser

 clear
	clear the framework cache including assets

 -h, --help
	display command info

extensions

 -s, --script
	extends [ start ] [ dev ]
	  run config SCRIPT_TAIL after spine build process

examples

 spine dev --script
	run dev build process and then run config defined script
	where SCRIPT_TAIL="npm dev". Can be used within framework
	environments such as the Electron framework

 spine open
	open the Public/index.html file using the machine's
	default web browser
```

Notes

-   `dev` and `start` commands are currently the same

## Routing

Self implemented hash router using hash anchors and CSS3.

### **Declare Routes**

VIEW and ROUTE are associated by line.

**Variables**

-   `VIEW`

    -   Unique
    -   Valid URL hash route

-   `ROUTE`
    -   Unique
    -   Relative file path from `Resources/views/content/`
    -   No file format suffix (`html` assumed)

```sh
# Resources/routes.sh
ROUTE 'home/' VIEW 'index'
ROUTE 'newpage/' VIEW 'new_page_dir/new_page_file'
```

### **View Navigation**

Methods to navigate between dynamic views.

**(Option 1) HTML**

```html
<!-- Prefix '#/' -->
<a href="#/newpage/" class="btn">Go New Page</a>
```

**(Option 2) JavaScript**

```html
<span id="home-button" class="btn">Go New Page</span>
```

```js
// On element click, redirect to new page
document.getElementById('home-button').addEventListener('click', function () {
    redirect('newpage/');
});
```

## Limitations

### File Naming

-   camelCase
-   PascalCase
-   snake_case
-   kebab-case

### Build

**JavaScript**

-   Files are not concatenated
-   File names are to be unique even in nested directories
-   (Recommendation) create single file if possible for performance

**Compression**

CSS and HTML compression support is good assuming correct coding practices. JavaScript compression support is beta, and support is limited (not recommended).

Pros

-   Remove comments
-   Remove whitespace

Cons

-   Variable names are unchanged
-   Semicolons not inserted

## Third-Party Support

The Spinebash framework does not, and tries not to limit developer-preferred dependencies.

### Recommendations

**Compressors**

Popular JavaScript compressors

-   [Terser](https://github.com/terser/terser)
-   [UglifyJS](https://github.com/mishoo/UglifyJS)

```sh
# .config

# Example usage
USE_COMPRESSOR_JS="terser INPUT -o OUTPUT"
```
