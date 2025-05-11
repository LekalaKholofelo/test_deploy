fetch('/welcome')
    .then(res => res.json())
    .then(data => {
        document.getElementById('welcome-text').textContent = data.message;
    })
    .catch(err => {
        document.getElementById('welcome-text').textContent = "Failed to load message.";
        console.error(err);
    });
