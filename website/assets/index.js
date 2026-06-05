	// Theme Toggle Logic
	function toggleTheme() {
		const isLight = document.documentElement.classList.contains('light-mode');
		if (isLight) {
			document.documentElement.classList.remove('light-mode');
			localStorage.setItem('theme', 'dark');
		} else {
			document.documentElement.classList.add('light-mode');
			localStorage.setItem('theme', 'light');
		}
	}
	
	// Watch for system preference changes
	window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', e => {
		if (!localStorage.getItem('theme')) {
			if (e.matches) {
				document.documentElement.classList.add('light-mode');
			} else {
				document.documentElement.classList.remove('light-mode');
			}
		}
	});

	// Translation Dictionary is loaded externally from website/pages/index_lang.js

	let currentLang = 'en';
	let activeTab = 'wall';

	// Language selection
	function initLang() {
		const supported = ['zh', 'zh-tw', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'id', 'th'];

		// Priority 1: URL path (/ja/) or query param (?lang=ja) - enforces language
		const pathParts = window.location.pathname.split('/').filter(p => p);
		const pathLang = pathParts.length > 0 ? pathParts[0] : null;
		
		const urlParams = new URLSearchParams(window.location.search);
		const paramLang = urlParams.get('lang');

		const explicitLang = supported.includes(pathLang) ? pathLang : (supported.includes(paramLang) ? paramLang : null);

		if (explicitLang) {
			currentLang = explicitLang;
			localStorage.setItem('lang', explicitLang); // Sync localStorage with URL
			applyLang();
			return;
		}

		// Priority 2: localStorage — user's previously saved preference
		const saved = localStorage.getItem('lang');
		if (saved && supported.includes(saved)) {
			currentLang = saved;
			applyLang();
			return;
		}

		// Priority 3: Browser language auto-detection
		const navLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase();
		if (navLang.startsWith('zh')) {
			if (navLang.includes('tw') || navLang.includes('hk') || navLang.includes('hant')) {
				currentLang = 'zh-tw';
			} else {
				currentLang = 'zh';
			}
		} else if (navLang.startsWith('ja')) {
			currentLang = 'ja';
		} else if (navLang.startsWith('ko')) {
			currentLang = 'ko';
		} else if (navLang.startsWith('fr')) {
			currentLang = 'fr';
		} else if (navLang.startsWith('de')) {
			currentLang = 'de';
		} else if (navLang.startsWith('es')) {
			currentLang = 'es';
		} else if (navLang.startsWith('it')) {
			currentLang = 'it';
		} else if (navLang.startsWith('pt')) {
			currentLang = 'pt';
		} else if (navLang.startsWith('id')) {
			currentLang = 'id';
		} else if (navLang.startsWith('th')) {
			currentLang = 'th';
		} else {
			currentLang = 'en';
		}
		applyLang();
	}

	// Language dropdown controls
	function toggleLangDropdown(e) {
		e.stopPropagation();
		const trigger = document.getElementById('lang-dropdown-trigger');
		const menu = document.getElementById('lang-dropdown-menu');
		trigger.classList.toggle('active');
		menu.classList.toggle('show');
	}

	function selectLang(lang) {
		switchLang(lang);
		const trigger = document.getElementById('lang-dropdown-trigger');
		const menu = document.getElementById('lang-dropdown-menu');
		if (trigger && menu) {
			trigger.classList.remove('active');
			menu.classList.remove('show');
		}
	}

	// Close dropdown when clicking outside
	window.addEventListener('click', () => {
		const trigger = document.getElementById('lang-dropdown-trigger');
		const menu = document.getElementById('lang-dropdown-menu');
		if (trigger && menu) {
			trigger.classList.remove('active');
			menu.classList.remove('show');
		}
	});

	function switchLang(lang) {
		localStorage.setItem('lang', lang);
		const supported = ['zh', 'zh-tw', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'id', 'th'];
		
		const pathParts = window.location.pathname.split('/').filter(p => p);
		const currentPathLang = pathParts.length > 0 ? pathParts[0] : null;
		
		if (currentPathLang && supported.includes(currentPathLang)) {
			// Update the path to the new language (Vercel pages)
			window.location.href = `/${lang}/`;
		} else if (new URLSearchParams(window.location.search).has('lang')) {
			// Update the query param to the new language (GH Pages links)
			window.location.href = `/?lang=${lang}`;
		} else {
			// Neither path nor query param is enforcing a language. Just change it in JS.
			currentLang = lang;
			applyLang();
		}
	}

	function applyLang() {
		// Map internal lang codes to BCP 47 html lang attribute values
		const htmlLangMap = {
			'zh': 'zh-Hans', 'zh-tw': 'zh-Hant', 'en': 'en',
			'ja': 'ja', 'ko': 'ko', 'fr': 'fr', 'de': 'de',
			'es': 'es', 'it': 'it', 'pt': 'pt', 'id': 'id', 'th': 'th'
		};
		// Update <html lang> so crawlers rendering JS see the correct language signal
		document.documentElement.lang = htmlLangMap[currentLang] || 'en';

		// Update dropdown trigger label and items active class
		const currentLangLabel = document.getElementById('current-lang-label');
		const langNames = {
			'zh': '简体中文',
			'zh-tw': '繁體中文',
			'en': 'English',
			'ja': '日本語',
			'ko': '한국어',
			'fr': 'Français',
			'de': 'Deutsch',
			'es': 'Español',
			'it': 'Italiano',
			'pt': 'Português',
			'id': 'Bahasa Indonesia',
			'th': 'ไทย'
		};
		
		if (currentLangLabel && langNames[currentLang]) {
			currentLangLabel.textContent = langNames[currentLang];
		}
		
		// Set active class on menu items
		document.querySelectorAll('.lang-dropdown-item').forEach(el => {
			const itemId = el.getAttribute('id');
			el.classList.toggle('active', itemId === `item-lang-${currentLang}`);
		});
		
		// Update dynamic text
		const dict = i18n[currentLang] || i18n['en'];
		document.querySelectorAll('[data-i18n]').forEach(el => {
			const key = el.getAttribute('data-i18n');
			if (dict[key]) {
				if (el.tagName === 'TITLE') {
					document.title = dict[key];
				} else {
					el.innerHTML = dict[key];
				}
			}
		});

		// Update dynamic meta tags so crawlers/social bots see the correct locale
		const metaDesc = document.querySelector('meta[name="description"]');
		if (metaDesc && dict['hero_subdesc']) metaDesc.setAttribute('content', dict['hero_subdesc']);
		const ogTitle = document.querySelector('meta[property="og:title"]');
		if (ogTitle && dict['app_name']) ogTitle.setAttribute('content', dict['app_name']);
		const ogDesc = document.querySelector('meta[property="og:description"]');
		if (ogDesc && dict['hero_desc']) ogDesc.setAttribute('content', dict['hero_desc']);
		const twTitle = document.querySelector('meta[name="twitter:title"]');
		if (twTitle && dict['app_name']) twTitle.setAttribute('content', dict['app_name']);
		const twDesc = document.querySelector('meta[name="twitter:description"]');
		if (twDesc && dict['hero_desc']) twDesc.setAttribute('content', dict['hero_desc']);

		// Update link paths
		document.getElementById('nav_download').href = `website/pages/download.html?lang=${currentLang}`;
		document.getElementById('nav_download_mobile').href = `website/pages/download.html?lang=${currentLang}`;
		
		// Hide QQ Group links for non-Chinese versions
		document.querySelectorAll('.zh-only').forEach(el => {
			el.style.display = (currentLang === 'zh' || currentLang === 'zh-tw') ? '' : 'none';
		});

		// Update screenshots based on current language
		updateShowcaseImages();
	}

	// Showcase Switch
	function switchShowcaseTab(tab) {
		activeTab = tab;
		
		// Tab buttons class
		document.getElementById('tab-wall').classList.toggle('active', tab === 'wall');
		document.getElementById('tab-decode').classList.toggle('active', tab === 'decode');

		// Image toggle
		document.getElementById('img-wall').classList.toggle('active', tab === 'wall');
		document.getElementById('img-decode').classList.toggle('active', tab === 'decode');
	}

	function updateShowcaseImages() {
		const wallImg = document.getElementById('img-wall');
		const decodeImg = document.getElementById('img-decode');
		
		if (currentLang === 'zh' || currentLang === 'zh-tw') {
			wallImg.src = 'website/assets/p1.zh.png';
			decodeImg.src = 'website/assets/p2.zh.png';
		} else {
			wallImg.src = 'website/assets/p1.en.png';
			decodeImg.src = 'website/assets/p2.en.png';
		}
	}

	// Mobile Navigation Drawer Toggle
	function toggleMobileNav() {
		const drawer = document.getElementById('mobile-drawer');
		drawer.classList.toggle('open');
	}

	// Close Mobile Drawer when a link is clicked
	document.querySelectorAll('#mobile-drawer a').forEach(link => {
		link.addEventListener('click', () => {
			document.getElementById('mobile-drawer').classList.remove('open');
		});
	});

	// Download logic
	function handleMainDownload(e) {
		e.preventDefault();
		
		const isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
		const versions = Object.keys(config);
		if (versions.length === 0) return;
		
		const latestVersion = versions[0];
		const latestData = config[latestVersion];
		
		let downloadLink = '';
		
		if (isMac) {
			const macItem = latestData.downloads.find(d => d.system === 'system_macos');
			if (macItem) {
				downloadLink = macItem.link;
			}
		} else {
			const winItem = latestData.downloads.find(d => d.system === 'system_windows' && d.suffix === 'suffix_zip' && d.type === 'type_1') 
						 || latestData.downloads.find(d => d.system === 'system_windows' && d.suffix === 'suffix_exe')
						 || latestData.downloads.find(d => d.system === 'system_windows');
			if (winItem) {
				downloadLink = winItem.link;
			}
		}
		
		if (!downloadLink) {
			window.location.href = `website/pages/download.html?lang=${currentLang}`;
			return;
		}
		
		window.location.href = downloadLink;
		
		if (isMac) {
			document.getElementById('macOsModal').classList.add('active');
		}
	}
	
	function closeMacOsModal() {
		document.getElementById('macOsModal').classList.remove('active');
	}

	// Initialize language on page load
	initLang();
