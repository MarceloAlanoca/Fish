    const modalOverlay = document.getElementById('bigModal');
        const modal = modalOverlay.querySelector('.modal');
        const closeBtn = modalOverlay.querySelector('.modal-close');
        const titleEl = document.getElementById('modalTitle');
        const dateEl = document.getElementById('modalDate');
        const imgEl = document.getElementById('modalImage');
        const detailEl = document.getElementById('modalDetail');
        const commentsList = document.getElementById('commentsList');
        const newComment = document.getElementById('newComment');
        const addCommentBtn = document.getElementById('addCommentBtn');

        document.addEventListener('click', e => {
        const reg = e.target.closest('.registro');
        if (reg) openModalFromElement(reg);
        });

        closeBtn.addEventListener('click', closeModal);
        modalOverlay.addEventListener('click', e => { if (e.target === modalOverlay) closeModal(); });
        document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

        addCommentBtn.addEventListener('click', () => {
        const text = newComment.value.trim();
        if (!text) return;
        const c = document.createElement('div');
        c.className = 'comment';
        c.innerHTML = `<div>${escapeHtml(text)}</div><small>Hace unos segundos</small>`;
        commentsList.prepend(c);
        newComment.value = '';
        });

        function openModalFromElement(el) {
        titleEl.textContent = el.dataset.titulo || '';
        dateEl.textContent = el.dataset.fecha || '';
        imgEl.src = el.dataset.img || '';
        imgEl.alt = titleEl.textContent;
        detailEl.textContent = el.dataset.detalle || '';
        commentsList.innerHTML = '';
        newComment.value = '';
        modalOverlay.classList.add('open');
        modalOverlay.setAttribute('aria-hidden','false');
        modal.focus();
        }

        function closeModal() {
        modalOverlay.classList.remove('open');
        modalOverlay.setAttribute('aria-hidden','true');
        }

        function escapeHtml(str) {
        return str.replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
        }