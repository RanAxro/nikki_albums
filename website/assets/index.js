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

	let currentLang = 'zh';
	let activeTab = 'wall';

	// Language selection
	function initLang() {
		const saved = localStorage.getItem('lang');
		if (saved && (saved === 'zh' || saved === 'en')) {
			currentLang = saved;
		} else {
			// Auto detect browser language
			const navLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase();
			if (navLang.startsWith('zh')) {
				currentLang = 'zh';
			} else {
				currentLang = 'en';
			}
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
		currentLang = lang;
		localStorage.setItem('lang', lang);
		applyLang();
	}

	function applyLang() {
		// Update dropdown trigger label and items active class
		const zhItem = document.getElementById('item-lang-zh');
		const enItem = document.getElementById('item-lang-en');
		const currentLangLabel = document.getElementById('current-lang-label');
		
		if (zhItem && enItem && currentLangLabel) {
			zhItem.classList.toggle('active', currentLang === 'zh');
			enItem.classList.toggle('active', currentLang === 'en');
			currentLangLabel.textContent = currentLang === 'zh' ? '简体中文' : 'English';
		}
		
		// Update dynamic text
		const dict = i18n[currentLang];
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

		// Update link paths
		document.getElementById('nav_download').href = `website/pages/download.html?lang=${currentLang}`;
		document.getElementById('nav_download_mobile').href = `website/pages/download.html?lang=${currentLang}`;
		
		// Hide QQ Group links for non-Chinese versions
		document.querySelectorAll('.zh-only').forEach(el => {
			el.style.display = currentLang === 'zh' ? '' : 'none';
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
		
		if (currentLang === 'zh') {
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
