# Spinebash
This is a Bash-built, dependency-free SPA framework which allows for a modular programming experience using HTML, CSS and JavaScript. 


and thus there are multiple limitations that could be fixed with added dependencies - notably compression tools such as the popular [Terser](https://github.com/terser/terser) and [UglifyJS](https://github.com/mishoo/UglifyJS).







## File Structure
**Resources/**

This directory contains all app resources and is mainly used throughout the development process.

**Public/**

This directory contains app asset files, constructed from the *Resources* directory.

**Framework/**

This directory contains all the framework resources.

**.config**

File containing configuration variables taking Boolean assignments ( `true` or `false` ).

**set_bash_alias.sh**

Temporary initialisation file to create the `spine` Bash alias used for the spine console.
```sh
# Run setup command
. ./set_bash_alias.sh
```
*Note: file should be removed after initialisation*


**spine**

Executable file acting as the Spinebash framework console.

`spine --help`
```
spine
 Usage: /usr/bin/bash <command>

commands

 dev, start
        build app assets in dev mode

 clear
        clear the framework cache including assets

 -h, --help
        display command info
```
*Note: `dev` and `start` commands are currently the same*
## Routing
Self implemented HashRouter using hash anchors.

**Usage**

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
`js/app.js`
```js
// Store element object
const el_home = document.getElementById('button');

// On click event, redirect to the test page (declared in routes.sh)
el_home.addEventListener('click',function(){
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

Written code will not be minified or validated
- Variable names are unchanged
- Semicolons not added