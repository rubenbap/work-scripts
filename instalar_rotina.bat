@echo off
:: Nome das tarefas no Agendador do Windows
set NOME_TAREFA=Rotina_1230
set NOME_TAREFA2=Rotina_1730

:: Caminho absoluto do teu script
set CAMINHO_COMPLETO=C:\SUPORTE\script.bat

echo A configurar a rotina para: %CAMINHO_COMPLETO%

:: Criação das tarefas agendadas via comando schtasks
:: /SC DAILY = Diariamente
:: /ST HH:MM = Hora de execucao
:: /F = Força a criação (sobrescreve se já existir)

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%CAMINHO_COMPLETO%\"" /sc daily /st 12:30 /f
schtasks /create /tn "%NOME_TAREFA2%" /tr "\"%CAMINHO_COMPLETO%\"" /sc daily /st 17:30 /f

echo.
echo Sucesso! As rotinas foram registadas no Windows.
echo O script '%CAMINHO_COMPLETO%' correra automaticamente as 12:30 e as 17:30 todos os dias.
echo Podes fechar esta janela.
pause