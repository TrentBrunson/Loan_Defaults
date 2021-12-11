USE [master]
GO

/****** Object:  Database [Loans]    Script Date: 12/10/2021 1:49:13 PM ******/
CREATE DATABASE [Loans]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Loans', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Loans.mdf' , SIZE = 1646592KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Loans_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Loans_log.ldf' , SIZE = 2433024KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Loans].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Loans] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Loans] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Loans] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Loans] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Loans] SET ARITHABORT OFF 
GO

ALTER DATABASE [Loans] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Loans] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Loans] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Loans] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Loans] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Loans] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Loans] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Loans] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Loans] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Loans] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Loans] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Loans] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Loans] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Loans] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Loans] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Loans] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Loans] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Loans] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [Loans] SET  MULTI_USER 
GO

ALTER DATABASE [Loans] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Loans] SET DB_CHAINING OFF 
GO

ALTER DATABASE [Loans] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [Loans] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [Loans] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [Loans] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [Loans] SET QUERY_STORE = OFF
GO

ALTER DATABASE [Loans] SET  READ_WRITE 
GO
