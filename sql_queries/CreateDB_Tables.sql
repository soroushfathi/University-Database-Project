-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema clothing_store
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema clothing_store
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `clothing_store` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `clothing_store` ;

-- -----------------------------------------------------
-- Table `clothing_store`.`Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Company` (
  `idCompany` INT NOT NULL,
  `companyLogo` VARBINARY(500) NULL,
  `companyAdderss` VARCHAR(45) NULL,
  PRIMARY KEY (`idCompany`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Person` (
  `idPerson` INT NOT NULL,
  `personFisrtName` VARCHAR(100) NOT NULL,
  `personLastName` VARCHAR(100) NOT NULL,
  `perosnEmail` VARCHAR(200) NOT NULL,
  `personBirthDate` DATE NULL,
  `age` INT NULL,
  `personType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPerson`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`User` (
  `idUser` INT NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `userAddress` VARCHAR(500) NULL,
  `Person_idPerson` INT NOT NULL,
  PRIMARY KEY (`idUser`),
  INDEX `fk_User_Person_idx` (`Person_idPerson` ASC) VISIBLE,
  CONSTRAINT `fk_User_Person`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `clothing_store`.`Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Customer` (
  `idCustomer` INT NOT NULL,
  `Person_idPerson` INT NOT NULL,
  PRIMARY KEY (`idCustomer`),
  INDEX `fk_Customer_Person1_idx` (`Person_idPerson` ASC) VISIBLE,
  CONSTRAINT `fk_Customer_Person1`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `clothing_store`.`Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`EmployeeAccess`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`EmployeeAccess` (
  `idEmployeeAccess` INT NOT NULL,
  `employeeAccessLevel` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEmployeeAccess`),
  UNIQUE INDEX `employeeAccessLevel_UNIQUE` (`employeeAccessLevel` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Department` (
  `idDepartment` INT NOT NULL,
  `deptName` VARCHAR(45) NOT NULL,
  `Company_idCompany` INT NOT NULL,
  PRIMARY KEY (`idDepartment`),
  INDEX `fk_Department_Company1_idx` (`Company_idCompany` ASC) VISIBLE,
  CONSTRAINT `fk_Department_Company1`
    FOREIGN KEY (`Company_idCompany`)
    REFERENCES `clothing_store`.`Company` (`idCompany`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Employee` (
  `idEmployee` INT NOT NULL,
  `EmployeeAccess_idEmployeeAccess` INT NOT NULL,
  `Person_idPerson` INT NOT NULL,
  `Department_idDepartment` INT NOT NULL,
  PRIMARY KEY (`idEmployee`),
  INDEX `fk_Employee_EmployeeAccess1_idx` (`EmployeeAccess_idEmployeeAccess` ASC) VISIBLE,
  INDEX `fk_Employee_Person1_idx` (`Person_idPerson` ASC) VISIBLE,
  INDEX `fk_Employee_Department1_idx` (`Department_idDepartment` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_EmployeeAccess1`
    FOREIGN KEY (`EmployeeAccess_idEmployeeAccess`)
    REFERENCES `clothing_store`.`EmployeeAccess` (`idEmployeeAccess`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_Person1`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `clothing_store`.`Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_Department1`
    FOREIGN KEY (`Department_idDepartment`)
    REFERENCES `clothing_store`.`Department` (`idDepartment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Category` (
  `idCategory` INT NOT NULL,
  `CategoryName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCategory`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Product` (
  `idProduct` INT NOT NULL,
  `Company_idCompany` INT NOT NULL,
  `Category_idCategory` INT NOT NULL,
  PRIMARY KEY (`idProduct`),
  INDEX `fk_Product_Company1_idx` (`Company_idCompany` ASC) VISIBLE,
  INDEX `fk_Product_Category1_idx` (`Category_idCategory` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Company1`
    FOREIGN KEY (`Company_idCompany`)
    REFERENCES `clothing_store`.`Company` (`idCompany`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Category1`
    FOREIGN KEY (`Category_idCategory`)
    REFERENCES `clothing_store`.`Category` (`idCategory`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Supplier` (
  `idSupplier` INT NOT NULL,
  `supplierName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSupplier`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Order` (
  `idOrder` INT NOT NULL,
  `orderAddress` VARCHAR(500) NOT NULL,
  `Customer_idCustomer` INT NOT NULL,
  PRIMARY KEY (`idOrder`),
  INDEX `fk_Order_Customer1_idx` (`Customer_idCustomer` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Customer1`
    FOREIGN KEY (`Customer_idCustomer`)
    REFERENCES `clothing_store`.`Customer` (`idCustomer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`OrderItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`OrderItem` (
  `idOrderItem` INT NOT NULL,
  `itemQuan` INT NULL,
  `itemTotalPrice` BIGINT(20) NULL,
  `Order_idOrder` INT NOT NULL,
  PRIMARY KEY (`idOrderItem`),
  INDEX `fk_OrderItem_Order1_idx` (`Order_idOrder` ASC) VISIBLE,
  CONSTRAINT `fk_OrderItem_Order1`
    FOREIGN KEY (`Order_idOrder`)
    REFERENCES `clothing_store`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`Variant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`Variant` (
  `idVariant` INT NOT NULL,
  `variantColor` VARCHAR(45) NULL,
  `variantQuan` INT NOT NULL,
  `variantSize` VARCHAR(45) NULL,
  `variantName` VARCHAR(45) NOT NULL,
  `variantUnitPrice` VARCHAR(45) NOT NULL,
  `variantDiscount` INT NULL,
  `Variantcol` VARCHAR(45) NULL,
  `Product_idProduct` INT NOT NULL,
  `Supplier_idSupplier` INT NOT NULL,
  `OrderItem_idOrderItem` INT NOT NULL,
  PRIMARY KEY (`idVariant`),
  INDEX `fk_Variant_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  INDEX `fk_Variant_Supplier1_idx` (`Supplier_idSupplier` ASC) VISIBLE,
  INDEX `fk_Variant_OrderItem1_idx` (`OrderItem_idOrderItem` ASC) VISIBLE,
  CONSTRAINT `fk_Variant_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `clothing_store`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Variant_Supplier1`
    FOREIGN KEY (`Supplier_idSupplier`)
    REFERENCES `clothing_store`.`Supplier` (`idSupplier`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Variant_OrderItem1`
    FOREIGN KEY (`OrderItem_idOrderItem`)
    REFERENCES `clothing_store`.`OrderItem` (`idOrderItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_store`.`PriceTracker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_store`.`PriceTracker` (
  `idPriceTracker` INT NOT NULL,
  `priceTrackerPrePrice` BIGINT(20) NOT NULL,
  `Variant_idVariant` INT NOT NULL,
  PRIMARY KEY (`idPriceTracker`),
  INDEX `fk_PriceTracker_Variant1_idx` (`Variant_idVariant` ASC) VISIBLE,
  CONSTRAINT `fk_PriceTracker_Variant1`
    FOREIGN KEY (`Variant_idVariant`)
    REFERENCES `clothing_store`.`Variant` (`idVariant`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
