package scripts

import (
	"fmt"
	"io/ioutil"
	"log"
	"path/filepath"
	"strings"

	"veloera/common"
	"veloera/model"
)

// InitializeDatabase 初始化数据库，如果是新安装则导入初始数据
func InitializeDatabase() error {
	if !common.UsingSQLite {
		log.Println("Database initialization is only supported for SQLite")
		return nil
	}

	// 检查是否已有数据（通过检查 users 表是否有记录）
	var count int64
	if err := model.DB.Table("users").Count(&count).Error; err != nil {
		return fmt.Errorf("failed to check existing data: %v", err)
	}

	// 如果已有用户数据，跳过初始化
	if count > 0 {
		log.Printf("Database already contains %d users, skipping initialization", count)
		return nil
	}

	log.Println("Initializing database with default data...")

	// 读取初始化脚本
	scriptPath := filepath.Join("scripts", "init_data.sql")
	sqlContent, err := ioutil.ReadFile(scriptPath)
	if err != nil {
		return fmt.Errorf("failed to read init script: %v", err)
	}

	// 执行 SQL 脚本
	if err := executeSQL(string(sqlContent)); err != nil {
		return fmt.Errorf("failed to execute init script: %v", err)
	}

	log.Println("Database initialization completed successfully")
	log.Println("Default admin user created: username=admin, password=admin123")
	log.Println("Please change the default password after first login!")

	return nil
}

// executeSQL 执行 SQL 脚本
func executeSQL(sqlContent string) error {
	// 获取底层的 SQL 连接
	sqlDB, err := model.DB.DB()
	if err != nil {
		return err
	}

	// 分割并执行每个语句
	statements := splitSQLStatements(sqlContent)
	for _, stmt := range statements {
		stmt = strings.TrimSpace(stmt)
		if stmt == "" || strings.HasPrefix(stmt, "--") {
			continue
		}

		if _, err := sqlDB.Exec(stmt); err != nil {
			log.Printf("Failed to execute SQL statement: %s", stmt)
			return err
		}
	}

	return nil
}

// splitSQLStatements 简单地按分号分割 SQL 语句
func splitSQLStatements(sql string) []string {
	statements := strings.Split(sql, ";")
	var result []string
	for _, stmt := range statements {
		stmt = strings.TrimSpace(stmt)
		if stmt != "" {
			result = append(result, stmt)
		}
	}
	return result
}
