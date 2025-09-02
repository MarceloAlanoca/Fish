 const form = document.getElementById('form');
        const password = document.getElementById('password');
        const passwordConfirm = document.getElementById('passwordConfirm');
        const mensaje = document.getElementById('mensaje');
        const showPassword = document.getElementById('showPassword');
        const showPasswordConfirm = document.getElementById('showPasswordConfirm');

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
        form.addEventListener('submit', function (event) {
            mensaje.textContent = '';
            if (password.value.trim().length < 5 || password.value.trim().length > 15) {
                event.preventDefault();
                mensaje.textContent = 'La contraseña debe tener entre 5 y 15 caracteres.';
                password.focus();
                return;
            }
            if (password.value !== passwordConfirm.value) {
                event.preventDefault();
                mensaje.textContent = 'Las contraseñas no coinciden, vuelve a intentar.';
                passwordConfirm.focus();
                return;
            }
        });