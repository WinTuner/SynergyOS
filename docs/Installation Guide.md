# 🛠️ SynergyOS User Installation Guide
 <details>
<summary>What <b>NOT</b> to do on SynergyOS, click to expand</summary>
<br/>

- Run any other `tweaks` or `optimizers` as SynergyOS is already tweaked. [SynToolkit](https://github.com/synergy-tweaks/syntoolkit) is an exception.
- Run any external Playbooks on top of SynergyOS. 

</details>

**Step 1 — Prepare**
- Use a fresh, stock Windows install. Supported builds (`playbook.conf`): `19044`, `19045`, `22000`, `22621`, `22631`, `22635`, `26100`, `26200`, `26300`. LTSC only counts where the build matches.
  - [Video Guide](https://youtu.be/Gat-aVYo8uY)
- Back up first. Defender removal and Edge removal are irreversible without a repair install.
- Meet the AME preflight checks before launching: internet connected, laptop plugged in, account password set, no pending Windows updates, no third-party AV installed.
- Download [AME Wizard](https://download.ameliorated.io/AME%20Beta.zip)
- Download [Latest Release of SynergyOS](https://github.com/synergy-tweaks/synergyos/releases) — only from this repo or the official Discord.

**Step 2**
- Launch `AME Wizard` as Administrator.
- Drag in the `SynergyOS.apbx` file into AME Wizard.
- If Dragging in doesn't work then click `Use Existing` and click on `SynergyOS.apbx`
<img width="684" height="480" alt="image" src="https://github.com/user-attachments/assets/42567c5a-e9e3-43b1-bf4f-93e982c3468b" />


**Step 3**
- Disable Security by Clicking on `Run Action`
- Click on `Open Windows Security` to toggle off the 4 settings.
  - Real-Time Protection
  - Cloud-Delivered Protection
  - Automatic Sample Submission
  - Tamper Protection
<img width="846" height="577" alt="image" src="https://github.com/user-attachments/assets/5bbae8b2-ae97-460e-b81b-215d87f85412" />
<img width="653" height="1350" alt="image" src="https://github.com/user-attachments/assets/a65b3829-e212-4c2d-8d8d-b6521813a889" />
<img width="849" height="579" alt="image" src="https://github.com/user-attachments/assets/3a33423d-285a-41ac-aee4-4e67313afdfb" />

**Step 4**
- Click `Next` so AME Wizard can Validate your `Windows Version` to determine if its Compatible with SynergyOS.
- Click `Next` again to Agree to the Licensing Agreements
<img width="689" height="477" alt="image" src="https://github.com/user-attachments/assets/0f99a18e-3bb5-4a85-9b86-2c540f5d6329" />
<img width="689" height="481" alt="image" src="https://github.com/user-attachments/assets/2fde25db-a204-4bb0-8406-824b26e6cc59" />
<img width="687" height="477" alt="image" src="https://github.com/user-attachments/assets/c33dc5c9-c234-49ab-a957-b29bc4abca15" />

**Step 5**
- Click on `Select Features`
- Choose your `Browser` of Choice. By Default `Brave` is Selected.
- Browser Options
  - None (If you already have a browser of choice installed.)
  - Google Chrome (We do not recommend Chrome for privacy reasons.)
  - Brave (Default Selection)
  - Firefox
- [Need Help? Join Our Discord!](https://dsc.gg/kwanteks)
<img width="690" height="475" alt="image" src="https://github.com/user-attachments/assets/4b2b77b5-dfbc-46ab-afcd-da2be7be020c" />
<img width="694" height="480" alt="image" src="https://github.com/user-attachments/assets/07e88bcf-4b65-4f82-b6d4-9a65cae2aff4" />

**Step 6**
- Select general tweaks to apply during SynergyOS installation.
- Selection Options
  - Install SynToolkit (Dedicated Application for Post Installation Management)
  - Remove Edge (irreversible but can be reinstalled later on)(Selected by Default)
  - Disable Xbox Services (Reversible by SynToolkit or Post Installation Folder)
  - Disable VBS / HVCI (Reduces Security / Reversible)
    - [Refer to this to understand security options.](https://github.com/Synergy-Tweaks/SynergyOS#security-options)

 - Optional security trade-offs. Leave unchecked unless you accept the risks.
   - Disable Defender (Reduces Security / Irreversible)
   - Disable Exploit Mitigations (Reduces Security / Reversible)
  **Some anti-cheat games require mitigations.**
- Choose whether User Account Control stays enabled or is disabled.
  - Disabling UAC removes all elevation prompts.
   - Enable UAC (Recommended)
   - Disable UAC (Reduces Security / Reversible)
  - Only disable UAC if you fully understand.
- Click  `Ok` after selecting your preferences 
- Click `Next` to begin the Process.
- During apply: close all apps and do not reboot until AME Wizard finishes.
<img width="688" height="479" alt="image" src="https://github.com/user-attachments/assets/1b81cd8a-6abb-44b6-833a-90a6ea671646" />
<img width="691" height="475" alt="image" src="https://github.com/user-attachments/assets/0aacc19d-6919-4c79-9f25-c44b167e589d" />
<img width="689" height="475" alt="image" src="https://github.com/user-attachments/assets/53bf3267-2f4a-4255-801d-19930fdf8d2e" />

**After install**
- Windows Update is paused until 2038 by default. Resume it from Settings > Windows Update when you want updates, then reopen AME Wizard and click `Run Again` if needed.
- If AME Wizard blocks you on validation (Step 4), recheck Step 1 preflights: pending updates, third-party AV, no password, offline, or unplugged laptop are the usual causes.
- Stuck? Ask in [Discord](https://dsc.gg/kwanteks) with your Windows build (`winver`), AME Wizard version, and a screenshot of the error.








