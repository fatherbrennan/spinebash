function redirect(route){window.location.hash=`/${route}`;}
// Navigate to the app home page defined in routes on startup
window.addEventListener('DOMContentLoaded', function() {
    if(window.location.hash === '' || !window.location.hash) {
        redirect('home/');
    }
});

document.getElementById('home-button').addEventListener('click',function(){
    redirect('newpage/');
})

document.getElementById('newpage-button').addEventListener('click',function(){
    redirect('home/');
})