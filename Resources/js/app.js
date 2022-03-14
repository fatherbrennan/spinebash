// Declare the app home route
const routeAppHome = 'home/';

// Navigate to the home page if no route is declared
window.addEventListener('DOMContentLoaded', function redirectHome() {
    if (window.location.hash === '' || !window.location.hash) redirect(routeAppHome);
});

// Listen to every hash navigation event and redirect to 404 page if invalid hash URL
window.addEventListener('hashchange', function redirectHashHandler() {
    // Treat 'index/' and 'index' as 'index/'
    const a = window.location.hash.replace(/^#\//, '').replace(/([\/]|)$/, '/');
    // Navigate to the home page if no route is declared
    if (a === '/') redirect(routeAppHome);
    // Navigate to 404 page if no valid route is declared
    else if (document.getElementById(`/${a}`) === null) redirect('http_404/');
    // Otherwise, navigate to declared route
    else redirect(a);
});

// JavaScript navigation
// -> Click the button on the new page to redirect back to the homepage
document.getElementById('newpage-button').addEventListener('click', function () {
    redirect('home/');
});
