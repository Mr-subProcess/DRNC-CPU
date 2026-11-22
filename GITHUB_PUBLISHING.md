# GitHub Publication Checklist

## Suggested repository metadata

- **Name:** `raqm-industrial-g77m`
- **Description:** `Research-only 256-bit RAQM vector datapath prototype for AMD Versal AI Edge Gen 2.`
- **Visibility:** Public, only if you intend the source to be publicly viewable and forkable.
- **License:** Keep the custom root `LICENSE` file. Do not select an MIT/GPL/Apache template in GitHub's license picker.
- **Topics:** `fpga`, `versal`, `systemverilog`, `axi4-stream`, `axi4-lite`, `hardware-research`, `vector-datapath`, `non-commercial`.

## Before the first push

1. Review `LICENSE` and confirm the non-commercial/no-production restrictions reflect your intent.
2. Review every file for secrets, credentials, private bitstreams, confidential vendor documents, or employer/customer material.
3. Confirm there are no guessed G77M B2B pin assignments or unverified carrier constraints.
4. Run `make check` locally.
5. Run `make rtl-test` with Icarus Verilog and `make rtl-lint` with Verilator; attach logs to the release when available.
6. Confirm that GitHub Actions passes on the first push.
7. Keep the repository description and README explicit that this is not an open-source license and commercial production is prohibited.
8. Do not upload the project under an organization or account unless you own/control the relevant rights.

## Example commands

Create an empty repository on GitHub with the name above, then from the project directory:

```bash
git init
git branch -M main
git add .
git status --short
git commit -m "Prepare RAQM Industrial 4.1.0 research release"
git remote add origin https://github.com/<YOUR_ACCOUNT>/raqm-industrial-g77m.git
git push -u origin main
```

Replace `<YOUR_ACCOUNT>` with your actual GitHub account or organization. Never put a personal access token directly in the remote URL or commit history. Use Git Credential Manager, SSH, or the official GitHub CLI authentication flow.

## First tagged release

After CI passes and the release gate is reviewed:

```bash
git tag -a v4.1.0 -m "RAQM Industrial 4.1.0"
git push origin v4.1.0
```

Do not tag a hardware-qualified or production release until all applicable items in `docs/RELEASE_CHECKLIST.md` are closed with evidence.
