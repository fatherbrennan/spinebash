// Navigate to the app home page defined in routes on startup
window.addEventListener('DOMContentLoaded', function() {
    if(window.location.hash === '' || !window.location.hash) {
        redirect('home/');
    }
});

// Click the button on home page to redirect to the newpage
document.getElementById('home-button').addEventListener('click',function(){
    redirect('newpage/');
})

// Click the button on the new page to redirect back to the homepage
document.getElementById('newpage-button').addEventListener('click',function(){
    redirect('home/');
})