=====================================================================
 SHADOW OF THE COLOSSUS – PORT NATIVO (SotC-PC v1.1): CORREÇÃO DE SAVE
=====================================================================

PROBLEMA
  O jogo não salva: aparece a mensagem de que não é possível salvar /
  armazenamento insuficiente ("memory card"), tanto no salvamento automático
  quanto no manual. Só o "Continuar" funciona com o save antigo.

CAUSA
  O port informa ao jogo pouco espaço livre (sceSaveDataGetMountInfo e
  sceSaveDataDirNameSearch) e o jogo conclui que não cabe o save, abrindo
  a mensagem de sistema "sem espaço" (SaveDataDialog, tipo 8
  NOSPACE_CONTINUABLE) sem nem tentar gravar.
  Além disso, o port ainda não tem a tela de lista de saves do sistema:
  cada save manual criava um slot novo e "Carregar" não fazia nada.

O QUE A CORREÇÃO FAZ
  1. O port passa a informar bastante espaço livre -> o jogo volta a salvar
     (automático e manual).
  2. Save manual grava sempre no mesmo slot (SAVEDATA0ShadowProgress1).
  3. "Carregar" no menu abre esse save manual. "Continuar" segue abrindo o
     save mais recente.
  Ainda não há tela: o save manual grava na hora, sem mostrar a lista.

COMO USAR
  1. Feche o jogo.
  2. Coloque esta pasta dentro da pasta do port (onde fica o SotC.exe).
  3. Dê dois cliques em "APLICAR - APPLY.bat".
  Para voltar ao original: "DESFAZER - UNDO.bat".

SEGURANÇA
  - Só altera o bin\bb-probe.exe da versão v1.1 (confere o SHA256 antes).
    Em outra versão, avisa e não muda nada.
  - Confere cada byte antes de alterar e o resultado depois.
  - Guarda o original como bin\bb-probe.exe.original-v1.1.
  - Faça backup dos seus saves: user\savedata\1\CUSA08809


=====================================================================
 SHADOW OF THE COLOSSUS – NATIVE PORT (SotC-PC v1.1): SAVE FIX
=====================================================================

PROBLEM
  The game does not save: you get the "cannot save / not enough storage"
  message for both autosave and manual save. Only "Continue" works.

CAUSE
  The port reports very little free space to the game
  (sceSaveDataGetMountInfo and sceSaveDataDirNameSearch), so the game
  decides the save does not fit and opens the system "no space" message
  (SaveDataDialog, type 8 NOSPACE_CONTINUABLE) without even trying to write.
  The port also has no system save-list screen yet: every manual save
  created a new slot and "Load" did nothing.

WHAT THE FIX DOES
  1. The port reports plenty of free space -> saving works again
     (autosave and manual).
  2. Manual save always writes the same slot (SAVEDATA0ShadowProgress1).
  3. "Load" in the menu opens that manual save. "Continue" still opens the
     most recent save.
  There is still no screen: a manual save is written immediately, with no list.

HOW TO USE
  1. Close the game.
  2. Put this folder inside the port folder (next to SotC.exe).
  3. Double-click "APLICAR - APPLY.bat".
  To restore the original: "DESFAZER - UNDO.bat".

SAFETY
  - Only patches bin\bb-probe.exe of v1.1 (SHA256 checked first). Any other
    build: it warns and changes nothing.
  - Every byte is checked before patching and the result is verified after.
  - The original is kept as bin\bb-probe.exe.original-v1.1.
  - Back up your saves: user\savedata\1\CUSA08809
