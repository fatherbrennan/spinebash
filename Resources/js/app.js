// Navigate to the app home page defined in routes on startup
window.addEventListener('DOMContentLoaded', function() {
    if(window.location.hash === '' || !window.location.hash) {
        redirect('home/');
    }
});


const el_home = document.getElementById('home-page');
el_home.addEventListener('click',function(){
    redirect('test/');
})