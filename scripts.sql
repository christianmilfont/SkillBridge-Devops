-- Script SQL usado nos Testes WorkBench

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
select * from users;
select * from competencies;
-- ===========================
-- TABLE: users
-- ===========================
CREATE TABLE `users` (
    `Id` CHAR(36) NOT NULL,
    `CreatedAt` DATETIME(6) NOT NULL,
    `Email` VARCHAR(255) NOT NULL,
    `PasswordHash` LONGTEXT NOT NULL,
    `Role` LONGTEXT NOT NULL,
    `Username` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`Id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- ===========================
-- TABLE: profiles
-- ===========================
CREATE TABLE `profiles` (
    `Id` CHAR(36) NOT NULL,
    `Bio` VARCHAR(1000) NOT NULL,
    `FullName` VARCHAR(200) NOT NULL,
    `Location` VARCHAR(150) NOT NULL,
    `UserId` CHAR(36),
    PRIMARY KEY (`Id`),
    UNIQUE KEY `IX_profiles_UserId` (`UserId`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- FK: Profile -> User (1:1)
ALTER TABLE `profiles`
    ADD CONSTRAINT `FK_profiles_users_UserId`
    FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`)
    ON DELETE CASCADE;
 
-- ===========================
-- TABLE: competencies
-- ===========================
CREATE TABLE `competencies` (
    `Id` CHAR(36) NOT NULL,
    `Description` VARCHAR(1000) NOT NULL,
    `Name` VARCHAR(150) NOT NULL,
    `RecommendedLevel` LONGTEXT NOT NULL,
    PRIMARY KEY (`Id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- ===========================
-- TABLE: courses
-- ===========================
CREATE TABLE `courses` (
    `Id` CHAR(36) NOT NULL,
    `CreatedAt` DATETIME(6) NOT NULL,
    `Description` VARCHAR(4000) NOT NULL,
    `DurationHours` INT NOT NULL,
    `Price` DECIMAL(10,2) NOT NULL,
    `Title` VARCHAR(250) NOT NULL,
    PRIMARY KEY (`Id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- ===========================
-- TABLE: vacancies
-- ===========================
CREATE TABLE `vacancies` (
    `Id` CHAR(36) NOT NULL,
    `ClosesAt` DATETIME(6),
    `Company` VARCHAR(200) NOT NULL,
    `Description` VARCHAR(4000) NOT NULL,
    `Location` VARCHAR(150) NOT NULL,
    `PostedAt` DATETIME(6) NOT NULL,
    `SalaryMax` DECIMAL(65,30),
    `SalaryMin` DECIMAL(65,30),
    `Status` LONGTEXT NOT NULL,
    `Title` VARCHAR(250) NOT NULL,
    PRIMARY KEY (`Id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- ===========================
-- TABLE: enrollments
-- ===========================
CREATE TABLE `enrollments` (
    `Id` CHAR(36) NOT NULL,
    `CourseId` CHAR(36) NOT NULL,
    `EnrolledAt` DATETIME(6) NOT NULL,
    `Progress` DOUBLE NOT NULL,
    `Score` DOUBLE,
    `Status` LONGTEXT NOT NULL,
    `UserId` CHAR(36) NOT NULL,
 
    PRIMARY KEY (`Id`),
    KEY `IX_enrollments_CourseId` (`CourseId`),
    KEY `IX_enrollments_UserId_CourseId` (`UserId`, `CourseId`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- FK: Enrollment -> User
ALTER TABLE `enrollments`
    ADD CONSTRAINT `FK_enrollments_users_UserId`
    FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`)
    ON DELETE CASCADE;
 
-- FK: Enrollment -> Course
ALTER TABLE `enrollments`
    ADD CONSTRAINT `FK_enrollments_courses_CourseId`
    FOREIGN KEY (`CourseId`) REFERENCES `courses` (`Id`)
    ON DELETE CASCADE;
 
-- ===========================
-- TABLE: recommendations
-- ===========================
CREATE TABLE `recommendations` (
    `Id` CHAR(36) NOT NULL,
    `CourseId` CHAR(36),
    `CreatedAt` DATETIME(6) NOT NULL,
    `ProfileId` CHAR(36) NOT NULL,
    `VacancyId` CHAR(36),
 
    PRIMARY KEY (`Id`),
    KEY `IX_recommendations_CourseId` (`CourseId`),
    KEY `IX_recommendations_ProfileId` (`ProfileId`),
    KEY `IX_recommendations_VacancyId` (`VacancyId`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
-- FK: Recommendation -> Course
ALTER TABLE `recommendations`
    ADD CONSTRAINT `FK_recommendations_courses_CourseId`
    FOREIGN KEY (`CourseId`) REFERENCES `courses` (`Id`);
 
-- FK: Recommendation -> Profile
ALTER TABLE `recommendations`
    ADD CONSTRAINT `FK_recommendations_profiles_ProfileId`
    FOREIGN KEY (`ProfileId`) REFERENCES `profiles` (`Id`)
    ON DELETE CASCADE;
 
-- FK: Recommendation -> Vacancy
ALTER TABLE `recommendations`
    ADD CONSTRAINT `FK_recommendations_vacancies_VacancyId`
    FOREIGN KEY (`VacancyId`) REFERENCES `vacancies` (`Id`);
 
-- ===========================
-- JOIN: course_competencies
-- ===========================
CREATE TABLE `course_competencies` (
    `CourseId` CHAR(36) NOT NULL,
    `CompetencyId` CHAR(36) NOT NULL,
    `CoveragePercent` INT NOT NULL,
    `RequiredLevel` INT NOT NULL,
 
    PRIMARY KEY (`CourseId`, `CompetencyId`),
    KEY `IX_course_competencies_CompetencyId` (`CompetencyId`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
ALTER TABLE `course_competencies`
    ADD CONSTRAINT `FK_course_competencies_courses_CourseId`
    FOREIGN KEY (`CourseId`) REFERENCES `courses` (`Id`)
    ON DELETE CASCADE;
 
ALTER TABLE `course_competencies`
    ADD CONSTRAINT `FK_course_competencies_competencies_CompetencyId`
    FOREIGN KEY (`CompetencyId`) REFERENCES `competencies` (`Id`)
    ON DELETE CASCADE;
 
-- ===========================
-- JOIN: profile_competencies
-- ===========================
CREATE TABLE `profile_competencies` (
    `ProfileId` CHAR(36) NOT NULL,
    `CompetencyId` CHAR(36) NOT NULL,
    `SelfAssessedLevel` LONGTEXT,
    `YearsExperience` INT,
 
    PRIMARY KEY (`ProfileId`, `CompetencyId`),
    KEY `IX_profile_competencies_CompetencyId` (`CompetencyId`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
ALTER TABLE `profile_competencies`
    ADD CONSTRAINT `FK_profile_competencies_profiles_ProfileId`
    FOREIGN KEY (`ProfileId`) REFERENCES `profiles` (`Id`)
    ON DELETE CASCADE;
 
ALTER TABLE `profile_competencies`
    ADD CONSTRAINT `FK_profile_competencies_competencies_CompetencyId`
    FOREIGN KEY (`CompetencyId`) REFERENCES `competencies` (`Id`)
    ON DELETE CASCADE;
 
-- ===========================
-- JOIN: vacancy_competencies
-- ===========================
CREATE TABLE `vacancy_competencies` (
    `VacancyId` CHAR(36) NOT NULL,
    `CompetencyId` CHAR(36) NOT NULL,
    `IsMandatory` TINYINT(1) NOT NULL,
    `RequiredLevel` LONGTEXT NOT NULL,
 
    PRIMARY KEY (`VacancyId`, `CompetencyId`),
    KEY `IX_vacancy_competencies_CompetencyId` (`CompetencyId`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
 
ALTER TABLE `vacancy_competencies`
    ADD CONSTRAINT `FK_vacancy_competencies_vacancies_VacancyId`
    FOREIGN KEY (`VacancyId`) REFERENCES `vacancies` (`Id`)
    ON DELETE CASCADE;
 
ALTER TABLE `vacancy_competencies`
    ADD CONSTRAINT `FK_vacancy_competencies_competencies_CompetencyId`
    FOREIGN KEY (`CompetencyId`) REFERENCES `competencies` (`Id`)
    ON DELETE CASCADE;



-- Passos para Testar o CRUD via MySQL Workbench
-- 1. Create (Criar) – Inserindo um User e um Profile novo
 
-- Primeiro, vamos criar um User e depois um Profile associado a ele.
 
-- Criação de um User:
 
INSERT INTO users (id, email, PasswordHash, role, username, CreatedAt)
VALUES (UUID(), 'usuario1@exemplo.com', '$2a$12$sxBFg/9voho1lEPoTTvqk.89jBX2neOl3hDbTW7KR1PHleuAiGrwW', 'admin', 'usuario1', NOW());
 
 
-- Criação de um Profile associado ao User:
-- Lembre-se que o Profile tem uma chave estrangeira para UserId.
 
INSERT INTO profiles (id, bio, FullName, Location, UserId)
VALUES (UUID(), 'Bio do usuário 1', 'Nome do Usuário 1', 'Localização 1', 
        (SELECT id FROM users WHERE username = 'usuario1'));
 
-- 2. Read (Ler) – Consultando um User e seu Profile
 
-- Agora, vamos fazer uma consulta para buscar o User e seu Profile.
 
-- Buscar o usuário pelo username e mostrar seu profile
SELECT u.id AS userid, u.username, p.id AS profileid, p.fullname, p.bio, p.location
FROM users u
JOIN profiles p ON u.id = p.userid
WHERE u.username = 'usuario1';
 
-- 3. Update (Atualizar) – Atualizando informações de um User ou Profile
 
-- Agora, vamos atualizar o Profile do User.
 
-- Atualizar informações do profile
UPDATE profiles 
SET fullname = 'Nome Atualizado', location = 'Localização Atualizada'
WHERE userid = (SELECT id FROM users WHERE username = 'usuario1');
 
 
-- 4. Delete (Excluir) – Excluindo um User e seu Profile
 
-- Agora, vamos excluir tanto o User quanto o Profile associado a ele. Por conta da restrição de chave estrangeira, ao deletar o User, o Profile também será removido devido à configuração de DeleteBehavior.Cascade no relacionamento.
 
-- Deletar o usuário e seu profile (cascata)
DELETE FROM users 
WHERE id = 'c502b948-c57f-11f0-95e7-00155d671ccd';
 
 
O--  comando acima irá excluir o User e o Profile associado a ele.
SET FOREIGN_KEY_CHECKS = 1;


-- Outros testes a mais que fizemos no Vídeo Plus
-- 1. CREATE – Criar um Enrollment
-- Antes disso, você deve ter um user e um course criados.
INSERT INTO enrollments (Id, CourseId, UserId, EnrolledAt, Progress, Score, Status)VALUES (
    UUID(),
    (SELECT Id FROM courses ORDER BY CreatedAt LIMIT 1),
    (SELECT Id FROM users WHERE username = 'usuario1'),
    NOW(),
    0.0,
    NULL,
    'InProgress');
-- 2. READ – Buscar enrollment com JOIN


SELECT 
    e.Id AS EnrollmentId,
    u.Username,
    c.Title AS CourseTitle,
    e.Progress,
    e.Score,
    e.Status,
    e.EnrolledAtFROM enrollments eJOIN users u ON e.UserId = u.IdJOIN courses c ON e.CourseId = c.Id;


-- 3. UPDATE – Atualizar progresso e nota
UPDATE enrollmentsSET Progress = 75.5,
    Score = 8.5,
    Status = 'Completed' WHERE Id = '<ID_DO_ENROLLMENT>';


-- 4. DELETE – Excluir um enrollment
-- DELETE FROM enrollmentsWHERE Id = '<ID_DO_ENROLLMENT>';
-- CRUD 2 – Profile_Competencies (tabela de relação N:N)
-- Relacionamentos
-- ProfileId → profiles.Id
-- CompetencyId → competencies.Id


-- 1. CREATE – Inserir uma competência no perfil
INSERT INTO profile_competencies (ProfileId, CompetencyId, SelfAssessedLevel, YearsExperience)VALUES (
    (SELECT Id FROM profiles LIMIT 1),
    (SELECT Id FROM competencies LIMIT 1),
    'Intermediate',
    2);


-- 2. READ – Buscar todas as competencies de um profile
SELECT 
    pc.ProfileId,
    p.FullName,
    c.Name AS Competency,
    pc.SelfAssessedLevel,
    pc.YearsExperienceFROM profile_competencies pcJOIN profiles p ON pc.ProfileId = p.IdJOIN competencies c ON pc.CompetencyId = c.IdWHERE p.Id = (SELECT Id FROM profiles LIMIT 1);


-- 3. UPDATE – Atualizar nível de uma competência
UPDATE profile_competenciesSET SelfAssessedLevel = 'Advanced', YearsExperience = 4 WHERE ProfileId = '<PROFILE_ID>'AND CompetencyId = '<COMPETENCY_ID>';


-- 4. DELETE – Remover competência do perfil
DELETE FROM profile_competenciesWHERE ProfileId = '<PROFILE_ID>'AND CompetencyId = '<COMPETENCY_ID>';
-- Agora os CRUDs em tabelas sem relacionamento nenhum
-- CRUD 3 – Competencies (sem FK)


-- 1. CREATE
INSERT INTO competencies (Id, Name, Description, RecommendedLevel)VALUES (UUID(), 'Lógica de Programação', 'Fundamentos de lógica', 'Beginner');

-- 2. READ – Buscar todas
SELECT * FROM competencies;

-- 3. UPDATE
UPDATE competenciesSET Description = 'Fundamentos essenciais de lógica de programação',
    RecommendedLevel = 'Intermediate' WHERE Name = 'Lógica de Programação';
-- 4. DELETE
DELETE FROM competenciesWHERE Name = 'Lógica de Programação';

-- CRUD 4 – Courses (sem FK diretamente)
-- 1. CREATE
INSERT INTO courses (Id, CreatedAt, Title, Description, DurationHours, Price)VALUES (
    UUID(),
    NOW(),
    'Curso de APIs com .NET',
    'Aprenda a criar APIs RESTful com .NET e C#',
    20,
    79.90);


-- 2. READ – Buscar todos
SELECT * FROM courses;


-- 3. UPDATE
UPDATE coursesSET Price = 99.90,
    DurationHours = 24 WHERE Title = 'Curso de APIs com .NET';


-- 4. DELETE
DELETE FROM coursesWHERE Title = 'Curso de APIs com .NET';