-- 1. Создание базы
CREATE DATABASE IF NOT EXISTS charity_site
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE charity_site;

-- ===============================
-- 2. Таблица: Пользователи (админы, волонтёры и т.д.)
-- ===============================
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(255),
  role ENUM('admin', 'moderator', 'volunteer', 'guest') DEFAULT 'guest',
  status ENUM('active', 'inactive', 'banned') DEFAULT 'active',
  registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- 3. Таблица: Пожертвования
-- ===============================
CREATE TABLE IF NOT EXISTS donations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT, -- foreign key
  donor_name VARCHAR(255),
  email VARCHAR(255),
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(10) DEFAULT 'KZT',
  method ENUM('card', 'crypto', 'bank', 'cash') DEFAULT 'card',
  transaction_id VARCHAR(255),
  status ENUM('pending', 'confirmed', 'failed') DEFAULT 'pending',
  donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ===============================
-- 4. Таблица: Проекты (кампании)
-- ===============================
CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  goal_amount DECIMAL(12,2),
  collected_amount DECIMAL(12,2) DEFAULT 0,
  deadline DATE,
  status ENUM('active', 'completed', 'archived') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- 5. Таблица: Поддержка / заявки / обращения
-- ===============================
CREATE TABLE IF NOT EXISTS support_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  message TEXT,
  subject VARCHAR(255),
  type ENUM('feedback', 'help', 'collab', 'other') DEFAULT 'other',
  status ENUM('open', 'in_progress', 'closed') DEFAULT 'open',
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- 6. Таблица: Подписки на новости / Email
-- ===============================
CREATE TABLE IF NOT EXISTS subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  confirmed BOOLEAN DEFAULT FALSE,
  subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- 7. Таблица: Волонтёры + их навыки
-- ===============================
CREATE TABLE IF NOT EXISTS volunteers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  bio TEXT,
  skills TEXT,
  available_days VARCHAR(255),
  location VARCHAR(255),
  joined_at DATE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ===============================
-- 8. Таблица: Мероприятия (эвенты)
-- ===============================
CREATE TABLE IF NOT EXISTS events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  description TEXT,
  location VARCHAR(255),
  event_date DATETIME,
  organizer_id INT,
  status ENUM('upcoming', 'past', 'cancelled') DEFAULT 'upcoming',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (organizer_id) REFERENCES users(id)
);

-- ===============================
-- 9. Таблица: Записи на мероприятия
-- ===============================
CREATE TABLE IF NOT EXISTS event_signups (
  id INT AUTO_INCREMENT PRIMARY KEY,
  event_id INT,
  user_id INT,
  status ENUM('registered', 'attended', 'cancelled') DEFAULT 'registered',
  signed_up_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ===============================
-- 10. Таблица: Новости / публикации
-- ===============================
CREATE TABLE IF NOT EXISTS news (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  content TEXT,
  cover_image VARCHAR(255),
  published_by INT,
  published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (published_by) REFERENCES users(id)
);

-- ===============================
-- 11. Таблица: Логи и события
-- ===============================
CREATE TABLE IF NOT EXISTS system_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  event_type VARCHAR(100),
  source_ip VARCHAR(45),
  payload JSON,
  user_agent TEXT,
  logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- 12. Таблица: Настройки сайта
-- ===============================
CREATE TABLE IF NOT EXISTS site_settings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  setting_key VARCHAR(255) UNIQUE,
  setting_value TEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);