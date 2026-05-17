# Disable TPM Checks During Boot
This repository documents practical ways to stop TPM-related boot delays/checks.

## When this helps
Use this if your machine stalls at boot with messages similar to:
- `Timed out waiting for device /dev/tpm0`
- `Timed out waiting for device /dev/tpmrm0`

## Method 1: Disable systemd TPM wait target (Linux)
If systemd is waiting for TPM devices, mask `tpm2.target`:

```bash
sudo systemctl mask tpm2.target
```

Then reboot:

```bash
sudo reboot
```

### Verify after reboot
Check that `tpm2.target` is masked:

```bash
systemctl show tpm2.target -p UnitFileState
```

Expected output:

```text
UnitFileState=masked
```

## Method 2: Disable TPM in UEFI/BIOS firmware
For systems doing firmware-level TPM checks before Linux starts:
1. Reboot and enter BIOS/UEFI setup.
2. Find TPM settings (often under **Security**, **Trusted Computing**, or **PCH-FW Configuration**).
3. Disable TPM (`TPM`, `PTT` for Intel, or `fTPM` for AMD).
4. Save and reboot.

## Re-enable TPM checks
If you need TPM again:

```bash
sudo systemctl unmask tpm2.target
sudo reboot
```

And re-enable TPM in BIOS/UEFI if you previously disabled it there.

## Security note
Disabling TPM can reduce platform security and may affect:
- full-disk-encryption key workflows bound to TPM
- measured boot / attestation
- OS features depending on secure hardware trust
