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

let activeTab = 'wall';

function toggleLangDropdown(e) {
  e.stopPropagation();
  const trigger = document.getElementById('lang-dropdown-trigger');
  const menu = document.getElementById('lang-dropdown-menu');
  trigger.classList.toggle('active');
  menu.classList.toggle('show');
}

// Language switch — direct redirect only, no storage, no dynamic loading
function selectLang(lang) {
	if (lang === 'zh') {
		window.location.href = '/';
	} else {
		window.location.href = '/' + lang + '/';
	}
}

// Showcase Switch
function switchShowcaseTab(tab) {
	activeTab = tab;
	
	// Tab buttons class
	document.getElementById('tab-wall').classList.toggle('active', tab === 'wall');
	document.getElementById('tab-decode').classList.toggle('active', tab === 'decode');
	document.getElementById('tab-parameter').classList.toggle('active', tab === 'parameter');
	document.getElementById('tab-lookbook').classList.toggle('active', tab === 'lookbook');

	// Image toggle
	document.getElementById('img-wall').classList.toggle('active', tab === 'wall');
	document.getElementById('img-decode').classList.toggle('active', tab === 'decode');
	document.getElementById('img-parameter').classList.toggle('active', tab === 'parameter');
	document.getElementById('img-lookbook').classList.toggle('active', tab === 'lookbook');
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
		window.location.href = 'download.html';
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