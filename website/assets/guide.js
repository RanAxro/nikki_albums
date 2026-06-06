document.addEventListener('DOMContentLoaded', () => {
	// 0. Sync localStorage lang preference with current page's lang attribute on load
	const htmlLang = document.documentElement.lang;
	if (htmlLang) {
		const langMap = {
			'zh-hans': 'zh',
			'zh-hant': 'zh-tw',
			'en': 'en',
			'ja': 'ja',
			'ko': 'ko',
			'fr': 'fr',
			'de': 'de',
			'es': 'es',
			'it': 'it',
			'pt': 'pt',
			'id': 'id',
			'th': 'th'
		};
		const matchedLang = langMap[htmlLang.toLowerCase()];
		if (matchedLang) {
			localStorage.setItem('lang', matchedLang);
		}
	}

	// 1. Theme Toggle Logic
	const themeToggleBtn = document.getElementById('theme-toggle-btn');
	if (themeToggleBtn) {
		themeToggleBtn.addEventListener('click', () => {
			const isLight = document.documentElement.classList.contains('light-mode');
			if (isLight) {
				document.documentElement.classList.remove('light-mode');
				localStorage.setItem('theme', 'dark');
			} else {
				document.documentElement.classList.add('light-mode');
				localStorage.setItem('theme', 'light');
			}
		});
	}

	// 2. Mobile Sidebar Drawer Logic
	const sidebarToggle = document.getElementById('sidebar-toggle');
	const sidebar = document.querySelector('.doc-sidebar');
	
	if (sidebarToggle && sidebar) {
		sidebarToggle.addEventListener('click', () => {
			sidebar.classList.toggle('active');
		});

		// Close sidebar when clicking links inside it (for mobile navigation)
		sidebar.querySelectorAll('.sidebar-link').forEach(link => {
			link.addEventListener('click', () => {
				sidebar.classList.remove('active');
			});
		});
	}

	// 3. Scroll-spy Logic for Active Sidebar Links
	const sections = document.querySelectorAll('.doc-content h2');

	function updateActiveOutline() {
		let currentSectionId = '';
		const scrollPosition = window.scrollY + 100; // Offset for header

		sections.forEach(section => {
			const sectionTop = section.offsetTop;
			if (scrollPosition >= sectionTop) {
				currentSectionId = section.getAttribute('id');
			}
		});

		// Highlight corresponding sidebar link
		document.querySelectorAll('.sidebar-link').forEach(link => {
			const targetHref = link.getAttribute('href');
			if (targetHref.startsWith('#')) {
				const targetId = targetHref.substring(1);
				if (targetId === currentSectionId) {
					link.classList.add('active');
				} else {
					link.classList.remove('active');
				}
			}
		});
	}

	window.addEventListener('scroll', updateActiveOutline);
	updateActiveOutline(); // Initial run

	// 4. Language Switcher Dropdown Toggle Logic
	const langDropdownBtn = document.querySelector('.lang-dropdown-btn');
	const langDropdownMenu = document.querySelector('.lang-dropdown-menu');
	if (langDropdownBtn && langDropdownMenu) {
		langDropdownBtn.addEventListener('click', (e) => {
			e.stopPropagation();
			langDropdownBtn.classList.toggle('active');
			langDropdownMenu.classList.toggle('show');
		});

		window.addEventListener('click', () => {
			langDropdownBtn.classList.remove('active');
			langDropdownMenu.classList.remove('show');
		});

		// Save selected language to localStorage to keep user preference in sync
		langDropdownMenu.querySelectorAll('.lang-dropdown-item').forEach(item => {
			item.addEventListener('click', () => {
				const langId = item.getAttribute('id');
				if (langId && langId.startsWith('lang-')) {
					const selectedLang = langId.replace('lang-', '');
					localStorage.setItem('lang', selectedLang);
				}
			});
		});
	}
});

