# Shadow of the Colossus native port (SotC-PC v1.1) — save fix

In the Shadow of the Colossus native port (SotC-PC v1.1) the game would not save: you got the "not enough storage" message for both autosave and manual save.

Cause: the port reports very little free space to the game (sceSaveDataGetMountInfo and sceSaveDataDirNameSearch), so the game decides the save does not fit and opens the system "no space" message (SaveDataDialog type 8, NOSPACE_CONTINUABLE) without trying to write. The log only shows "SaveDataDialog opened; completed immediately (no dialog UI yet)" and no "save data ... mounted".

The fix is a patcher (PowerShell, built into Windows) for bin\bb-probe.exe:
1. reports plenty of free space, so saving works again (autosave and manual);
2. manual save always writes the same slot (SAVEDATA0ShadowProgress1); without the list screen, every save created a new slot;
3. "Load" opens that manual save ("Continue" still opens the most recent one).

It checks the v1.1 SHA256 first, verifies every byte, keeps the original and includes an undo .bat.
Tested: autosave, manual save (always the same slot), Load and Continue.

For the port author: the proper fix is a SaveDataDialog LIST-mode screen and larger free-space values in GetMountInfo/DirNameSearch.

## How to use
1. Close the game.
2. Download this repo (Code → Download ZIP) or the release zip and put the folder inside the port folder (next to `SotC.exe`).
3. Double-click `APLICAR - APPLY.bat`. To restore the original: `DESFAZER - UNDO.bat`.

Back up your saves first: `user\savedata\1\CUSA08809`.

---

## Português

No port nativo do Shadow of the Colossus (SotC-PC v1.1) o jogo não salvava: aparecia a mensagem de armazenamento insuficiente, no save automático e no manual.

Causa: o port informa pouco espaço livre ao jogo (sceSaveDataGetMountInfo e sceSaveDataDirNameSearch). Com isso o jogo conclui que o save não cabe e abre a mensagem de sistema "sem espaço" (SaveDataDialog tipo 8, NOSPACE_CONTINUABLE) sem tentar gravar. No log aparece só "SaveDataDialog opened; completed immediately (no dialog UI yet)" e nenhum "save data ... mounted".

A correção é um patcher (PowerShell, já vem no Windows) que altera o bin\bb-probe.exe:
1. informa bastante espaço livre, e o jogo volta a salvar (automático e manual);
2. o save manual grava sempre no mesmo slot (SAVEDATA0ShadowProgress1); sem a tela de lista, cada save criava um slot novo;
3. "Carregar" abre esse save manual ("Continuar" segue abrindo o mais recente).

Ele confere o SHA256 da v1.1 antes de mexer, confere cada byte, guarda o original e tem um .bat para desfazer.
Testado: save automático, save manual (sempre no mesmo slot), Carregar e Continuar.

Para o autor do port: o ideal é implementar a tela da SaveDataDialog (modo LIST) e devolver valores de espaço maiores em GetMountInfo/DirNameSearch.

Como usar: veja `LEIA-ME - README.txt`.
