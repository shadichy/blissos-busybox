# **Build DEB Package**  
*Build a DEB package and produce artifacts for the current project.*  

![GitHub Marketplace](https://img.shields.io/badge/GitHub-Marketplace-blue.svg)  
<!-- [![Test Workflow](https://github.com/DevChall-by-SDCY-and-VXM/build-deb-repo/actions/workflows/test.yml/badge.svg)](https://github.com/DevChall-by-SDCY-and-VXM/build-deb-repo/actions/workflows/test.yml)   -->
[![License](https://img.shields.io/github/license/DevChall-by-SDCY-and-VXM/build-deb-repo.svg)](LICENSE)

## **Overview**  
This GitHub Action builds a DEB package for a project and produces an artifact containing the package and metadata. It supports customization for Debian-based distributions, architecture, and build options.

---

## **Features**  
- 🚀 **Build for multiple architectures**: Supports AMD64 and other architectures.  
- 🔧 **Customizable build options**: Pass arguments and options to the build process.  
- 💡 **Supports GPG signing**: Optionally sign packages with a GPG key.  

---

## **Usage**  

### **Basic Example**  
```yaml
name: Build DEB Package
on:
  push:
    branches:
      - main
jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Build DEB Package
        uses: DevChall-by-SDCY-and-VXM/build-deb-repo@v0.0.13
        with:
          distro: "debian:latest"
          arch: "amd64"
          build_arguments: "-b"
```

### **Inputs**  
| Name                  | Required | Default          | Description                                                                 |
|-----------------------|----------|------------------|-----------------------------------------------------------------------------|
| `distro`              | ✅       | `debian:latest`  | The Debian-based Linux distribution to build the package for.               |
| `arch`                | ✅       | `amd64`          | The architecture to build the package for.                                  |
| `build_arguments`     | ✅       | `-b`             | Arguments to pass to the `dpkg-buildpackage` command.                       |
| `build_options`       | ✅       | `""`            | Options to pass to the build process (via `DEB_BUILD_OPTIONS`).             |
| `build_profiles`      | ✅       | `""`            | Profiles to pass to the build process (via `DEB_BUILD_PROFILES`).           |
| `gpg_signing_key`     | ❌       | `null`           | The GPG key to use for signing the package.                                 |
| `package_name`        | ❌       | `null`           | Overrides the name of the package to build.                                 |
| `package_version`     | ❌       | `null`           | Overrides the version of the package to build.                              |
| `package_maintainer`  | ❌       | `null`           | Overrides the maintainer of the package. Syntax: `Name <email@example.com>`.|
| `package_class`       | ✅       | `s`              | Set the package class. Options: `s` (single), `i` (arch-independent), etc.  |
| `package_generate_orig` | ❌     | `false`          | Generate the `.orig` source package.                                        |

### **Outputs**  
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| `artifact_path`| The path to the generated DEB packages, build information, and metadata file.    |

---

## **Advanced Usage**  

### Generate build files and build
```yaml
name: Advanced DEB Workflow
on:
  pull_request:
    types:
      - opened
      - synchronized
jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Build DEB Package with Custom Options
        uses: DevChall-by-SDCY-and-VXM/build-deb-repo@v0.0.13
        with:
          distro: "ubuntu:20.04"
          arch: "arm64"
          build_arguments: "-us -uc"
          build_options: "parallel=4"
          gpg_signing_key: "<GPG_KEY>"
          package_name: "custom-package"
          package_version: "1.0.0"
          package_class: "l"
```

---

## **Contributing**  
<!-- We welcome contributions! See the [CONTRIBUTING.md](CONTRIBUTING.md) file for details on how to get involved. -->

---

## **License**  
<!-- This build-deb-repository is licensed under the [LICENSE_NAME](LICENSE) License. See the [LICENSE](LICENSE) file for details. -->

---

## **Support**  
If you encounter any issues, please [open an issue](https://github.com/DevChall-by-SDCY-and-VXM/build-deb-repo/issues). For additional support, reach out via [email/contact method].

---

## **Changelog**  
<!-- See the [CHANGELOG.md](CHANGELOG.md) for recent updates and changes. -->

---

## **Marketplace Link**  
[View on GitHub Marketplace](https://github.com/marketplace/actions/build-deb-package)
