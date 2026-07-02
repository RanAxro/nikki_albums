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

function toggleLangDropdown(e) {
	e.stopPropagation();
	const trigger = document.getElementById('lang-dropdown-trigger');
	const menu = document.querySelector('.lang-dropdown-menu');
	trigger.classList.toggle('active');
	menu.classList.toggle('show');
}

function toggleMobileNav() {
	const drawer = document.getElementById('mobile-drawer');
	drawer.classList.toggle('open');
}

function translate(key) {
	return i18n[key] || key;
}

function getLatestVersion() {
	return Object.keys(config)[0];
}

function getVersionDescription(version) {
	const versionData = config[version];
	if (!versionData || !versionData.description) return '';
	return versionData.description[currentLang] || versionData.description['zh'] || '';
}

function renderVersionList() {
	const menu = document.getElementById('versionMenu');
	if (!menu) return;
	const versions = Object.keys(config);
	const latestVersion = getLatestVersion();
	menu.innerHTML = '';
	versions.forEach((version, index) => {
		const item = document.createElement('li');
		item.className = 'sidebar-item';
		const link = document.createElement('a');
		link.className = `sidebar-link${index === 0 ? ' active' : ''}`;
		link.href = `#version-${version}`;
		link.dataset.version = version;
		link.innerHTML = `<span>${version}</span>${index === 0 ? '<span class="version-pill">'+translate('latest_badge')+'</span>' : ''}`;
		link.addEventListener('click', (event) => {
			event.preventDefault();
			selectVersion(version);
		});
		item.appendChild(link);
		menu.appendChild(item);
	});
	menu.querySelectorAll('.sidebar-link').forEach((link) => {
		link.addEventListener('click', () => {
			document.querySelector('.doc-sidebar').classList.remove('active');
		});
	});
}

function selectVersion(version) {
	const versions = Object.keys(config);
	const latestVersion = getLatestVersion();
	const currentVersion = version;
	const title = document.getElementById('versionTitle');
	const badge = document.getElementById('activeVersionBadge');
	const meta = document.getElementById('versionMeta');
	const notes = document.getElementById('releaseNotes');
	const links = document.getElementById('downloadLinks');

	if (!title || !badge || !meta || !notes || !links) return;

	document.querySelectorAll('.sidebar-link').forEach((link) => {
		link.classList.toggle('active', link.dataset.version === currentVersion);
	});

	title.textContent = `${translate('version_label')} ${currentVersion}`;
	badge.textContent = currentVersion === latestVersion ? translate('latest_badge') : '';
	badge.style.display = currentVersion === latestVersion ? 'inline-flex' : 'none';
	meta.innerHTML = `<span>${config[currentVersion].releaseDate}</span>`;
	notes.innerHTML = `<p>${getVersionDescription(currentVersion).replace(/\n/g, '<br>')}</p>`;
	links.innerHTML = '';
	config[currentVersion].downloads.forEach((item) => {
		const linkEl = document.createElement('a');
		linkEl.className = 'download-item';
		const isMac = item.system === 'system_macos';
		linkEl.href = isMac ? 'javascript:void(0)' : item.link;
		linkEl.target = '_blank';
		linkEl.rel = 'noopener noreferrer';
		if (isMac) {
			linkEl.addEventListener('click', (event) => {
				event.preventDefault();
				showMacOsModal(item.link);
			});
		}
		const typeLabel = item.type ? translate(item.type) : '';
		const variantLabel = item.variant ? translate(item.variant) : '';
		const platformIcon = item.system === 'system_windows' ? icons.windows : (item.system === 'system_macos' ? icons.macos : icons.android);
		linkEl.innerHTML = `
			<div class="download-info">
				<div class="platform-icon">
					<img src="${platformIcon}">
				</div>
				<div class="platform-details">
					<span class="platform-name">${translate(item.system)} ${variantLabel}</span>
					<div class="file-meta">
						<span>${translate(item.suffix)}</span>
						${typeLabel ? `<span>${typeLabel}</span>` : ''}
					</div>
				</div>
		</div>
		<div class="download-btn">
			<img src="${icons.download}">
		</div>`;
		links.appendChild(linkEl);
	});
}

function showMacOsModal(link) {
	const modal = document.getElementById('macOsModal');
	const confirmBtn = document.getElementById('macOsModalConfirm');
	if (!modal || !confirmBtn) {
		window.location.href = link;
		return;
	}
	confirmBtn.dataset.downloadUrl = link;
	modal.classList.add('active');
}

document.addEventListener('DOMContentLoaded', () => {
	const themeToggleBtn = document.getElementById('theme-toggle-btn');
	if (themeToggleBtn) {
		themeToggleBtn.addEventListener('click', toggleTheme);
	}

	const langDropdownBtn = document.querySelector('.lang-dropdown-btn');
	const langDropdownMenu = document.querySelector('.lang-dropdown-menu');
	if (langDropdownBtn && langDropdownMenu) {
		langDropdownBtn.addEventListener('click', toggleLangDropdown);
		window.addEventListener('click', () => {
			langDropdownBtn.classList.remove('active');
			langDropdownMenu.classList.remove('show');
		});
	}

	const sidebarToggle = document.getElementById('sidebar-toggle');
	const sidebar = document.querySelector('.doc-sidebar');
	if (sidebarToggle && sidebar) {
		sidebarToggle.addEventListener('click', () => {
			sidebar.classList.toggle('active');
		});
	}

	document.querySelectorAll('#mobile-drawer a').forEach((link) => {
		link.addEventListener('click', () => {
			document.getElementById('mobile-drawer').classList.remove('open');
		});
	});

	const modal = document.getElementById('macOsModal');
	const modalConfirm = document.getElementById('macOsModalConfirm');
	if (modal && modalConfirm) {
		modalConfirm.addEventListener('click', () => {
			const downloadUrl = modalConfirm.dataset.downloadUrl;
			modal.classList.remove('active');
			if (downloadUrl) {
				window.location.href = downloadUrl;
			}
		});
		modal.addEventListener('click', (event) => {
			if (event.target === modal) {
				modal.classList.remove('active');
			}
		});
	}

	renderVersionList();
	selectVersion(getLatestVersion());
});
