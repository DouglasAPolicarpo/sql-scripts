-- Declaração de Variáveis de Inicio e Fim para a tabela
DECLARE @StartDate DATE = '2026-01-01';
DECLARE @EndDate DATE = '2026-12-31';

-- Insere as datas no intervalo especificado
WITH CTE_Calendario AS (
    SELECT @StartDate AS Data
    UNION ALL
    SELECT DATEADD(DAY, 1, Data)
    FROM CTE_Calendario
    WHERE Data < @EndDate
)
INSERT INTO Calendario (Data, Ano, Mes, Dia, NomeMes, Trimestre, Semana, DiaSemana, DiaUtil, Quinzena)
SELECT 
    Data,
    YEAR(Data) AS Ano,
    MONTH(Data) AS Mes,
    DAY(Data) AS Dia,
    DATENAME(MONTH, Data) AS NomeMes,
    DATEPART(QUARTER, Data) AS Trimestre,
    DATEPART(WEEK, Data) AS Semana,
    DATENAME(WEEKDAY, Data) AS DiaSemana,
    CASE 
        WHEN DATENAME(WEEKDAY, Data) IN ('Saturday', 'Sunday') THEN 0 
        ELSE 1 
    END AS DiaUtil,
    CASE 
        WHEN DAY(Data) <= 15 THEN 1 
        ELSE 2 
    END AS Quinzena
FROM CTE_Calendario
WHERE NOT EXISTS (SELECT 1 FROM Calendario WHERE Data = CTE_Calendario.Data)
OPTION (MAXRECURSION 0);
