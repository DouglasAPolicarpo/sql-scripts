-- Declaração de variáveis
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2025-12-31';

-- Verifica se a tabela já existe e cria se necessário
IF OBJECT_ID('dbo.Calendario', 'U') IS NULL
BEGIN
    CREATE TABLE Calendario (
        Data DATE PRIMARY KEY,
        Ano INT,
        Mes INT,
        Dia INT,
        NomeMes NVARCHAR(20),
        Trimestre INT,
        Semana INT,
        DiaSemana NVARCHAR(20),
        DiaUtil BIT
    );
END;

-- Insere as datas no intervalo especificado
WITH CTE_Calendario AS (
    SELECT @StartDate AS Data
    UNION ALL
    SELECT DATEADD(DAY, 1, Data)
    FROM CTE_Calendario
    WHERE Data < @EndDate
)
INSERT INTO Calendario (Data, Ano, Mes, Dia, NomeMes, Trimestre, Semana, DiaSemana, DiaUtil)
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
    END AS DiaUtil
FROM CTE_Calendario
WHERE NOT EXISTS (SELECT 1 FROM Calendario WHERE Data = CTE_Calendario.Data)
OPTION (MAXRECURSION 0);
-- Teste