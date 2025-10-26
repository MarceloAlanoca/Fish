        const form = document.getElementById('form');
        const password = document.getElementById('password');
        const showPassword = document.getElementById('showPassword');

        showPassword.addEventListener('change', () => {
            if (showPassword.checked) {
                password.type = 'text';
            } else {
                password.type = 'password';
            }
        });
        showPasswordConfirm.addEventListener('change', () => {
            if (showPasswordConfirm.checked) {
                passwordConfirm.type = 'text';
            } else {
                passwordConfirm.type = 'password';
            }
        });