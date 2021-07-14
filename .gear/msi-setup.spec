%define _unpackaged_files_terminate_build 1

Name: msi-setup
Version: 0.1.0
Release: alt1

Summary: ADMX msi file downloader and extractor
License: GPLv2+
Group: Other
Url: https://github.com/august-alt/msi-setup

Requires: msitools, wget

Source0: %name-%version.tar

%description
Downlaods specified ADMX package and extracts it in desired location.

%prep
%setup -q

%install
mkdir -p %buildroot/%_bindir
install -D msi-setup.sh %buildroot/%_bindir/msi-setup

%files
%doc README.md
%_bindir/msi-setup

%changelog
* Wed Jul 14 2021 Vladimir Rubanov <august@altlinux.org> 0.1.0-alt1
- Initial build

