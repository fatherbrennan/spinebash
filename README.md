# Spinebash
This is a Bash-built, dependency-free SPA framework which allows for a modular programming experience using HTML, CSS and JavaScript. 
## File Structure
**Resources/**

This directory contains all app resources and is mainly used throughout the development process.

**Public/**

This directory contains app asset files, constructed from the *Resources* directory.

**Framework/**

This directory contains all the framework resources.

**.config**

File containing configuration variables taking Boolean assignments ( `true` or `false` ).

**set_alias.sh**

Temporary initialisation file to create the `spine` alias command used for the spine console. The alias will be added to the Bash and Zsh *rc file (although all scripts will use Bash interpreter).
```sh
# Run setup command
. ./set_alias.sh
```
*Note: file should be removed after initialisation*

*Note: file may need correct permissions: `chmod 755 set_alias.sh`*


**spine**

Executable file acting as the Spinebash framework console.

`spine --help`
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

exmaples

 spine dev --script
        run dev build process and then run config defined script
        where SCRIPT_TAIL="npm dev". Can be used within framework
        environments such as the Electron framework

 spine open
        open the Public/index.html file using the machine's
        default web browser
```
*Note: `dev` and `start` commands are currently the same*
## Routing
Self implemented HashRouter using hash anchors.

**Declare**

`routes.sh`
|Variable|Description|
|-|-|
|ROUTE|(Unique) URL Hash route|
|VIEW|(Unique) Relative file path from: `Resources/views/content/`|
```sh
# Decalre app routes
ROUTE 'home/' VIEW 'index'
ROUTE 'test/' VIEW 'test_dir/test_file'
```
**Option 1: HTML**

```html
<a href="#test/" class="btn">Go New Page</a>
```

**Option 2: JavaScript**

```html
<span id="button" class="btn">Go New Page</span>
```
```js
// On element click, redirect to new page
document.getElementById('button').addEventListener('click',function(){
    redirect('test/');
})
```
## Limitations
### File Naming
- camelCase
- PascalCase
- snake_case
- kebab-case
### Build
**JavaScript**
- Files are not concatenated
- File names are to be unique even in nested directories

It is recommended to create a single file if possible for performance.

**Compresson**

CSS and HTML compression support is good assuming correct coding practices. JavaScript compression support is beta, and support is limited (not recommended).

Pros
- Remove comments
- Remove whitespace

Cons
- Variable names are unchanged
- Semicolons not inserted

## Third-Party Support

The Spinebash framework does not, and tries not to limit developer-preferred dependencies.

### Recommendations

**Compressors**

The popular [Terser](https://github.com/terser/terser) and [UglifyJS](https://github.com/mishoo/UglifyJS) for JavaScript compression.
