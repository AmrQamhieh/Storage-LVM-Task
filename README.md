# Storage LVM Ansible Project

## Description
This project uses **Ansible** to:
- Create LVM on `/dev/sdb`
- Create two Logical Volumes
- Mount:
  - `/var/app1` **persistently** (survives reboot)
  - `/var/cache/app1` **non-persistently** (runtime only)
- Reboot the system and verify the result

After reboot:
- `/var/app1` is mounted
- `/var/cache/app1` is NOT mounted

---

## Requirements
- Linux system with an unused disk at `/dev/sdb`
- Ansible installed
- sudo privileges

---

## Setup & Run

### 1. Clone the project
```bash
git clone <repo-url>
cd Storage-LVM-Task
```

### 2. Install required Ansible collection
```bash
ansible-galaxy collection install -r requirements.yml
```

### 3. Verify disk exists
```bash
lsblk
```
Make sure `/dev/sdb` is present and unused.

### 4. Run the playbook
```bash
ansible-playbook -i inventory playbook.yml -K
```

Enter your sudo password when prompted.

---

## Verification (after reboot)
```bash
findmnt /var/app1
findmnt /var/cache/app1
```

Only `/var/app1` should be mounted.

---

## Notes
- Inventory is configured for `localhost`
- All variables are defined in `group_vars/all.yml`
- The project is organized using roles for clarity
