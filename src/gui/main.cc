/*
 *  Copyright (C) 2008  Alexandre Courbot
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "core/Paths.h"
#include "core/Preferences.h"
#include "core/Database.h"
#include "core/Tag.h"
#include "core/Entry.h"
#include "core/EntriesCache.h"
#include "core/Plugin.h"
#include "core/jmdict/JMdictPlugin.h"
#include "core/kanjidic2/Kanjidic2Plugin.h"
#include "gui/PreferencesWindow.h"
#include "gui/MainWindow.h"

#include "core/jmdict/JMdictPlugin.h"
#include "core/kanjidic2/Kanjidic2Plugin.h"
#include "gui/jmdict/JMdictGUIPlugin.h"
#include "gui/kanjidic2/Kanjidic2GUIPlugin.h"

#include <QApplication>
#include <QSettings>
#include <QDesktopServices>
#include <QTranslator>
#include <QLocale>
#include <QSqlRecord>
#include <QSqlError>
#include <QMessageBox>

// The version must be defined by the compiler
#ifndef VERSION
#error No version defined - the -DVERSION=<version> flag must be set!
#endif

/**
 * Message handler
 */
void messageHandler(QtMsgType type, const char *msg)
{
	switch (type) {
	case QtDebugMsg:
		fprintf(stderr, "Debug: %s\n", msg);
		break;
	case QtWarningMsg:
		fprintf(stderr, "Warning: %s\n", msg);
		break;
	case QtCriticalMsg:
		fprintf(stderr, "Critical: %s\n", msg);
		break;
	case QtFatalMsg:
		QMessageBox::critical(0, "Tagaini Jisho fatal error", msg);
		fprintf(stderr, "Fatal: %s\n", msg);
		abort();
	}
}

/**
 * Check if a user DB directory is defined in the application settings, and
 * create a default one in case it doesn't exist.
 */
void checkUserProfileDirectory()
{
	QString profileDirName;
	// Set the userProfile variable if not existing
	if (Database::userProfile.isDefault()) {
		profileDirName = QDesktopServices::storageLocation(QDesktopServices::DataLocation);
		Database::userProfile.set(profileDirName);
	}
	else profileDirName = Database::userProfile.value();

	// Create the user profile directory if not existing
	QDir profileDir(profileDirName);
	if (!profileDir.exists()) profileDir.mkpath(".");

	// Replace the data file by the imported one if existing
	QFile dataFile(QDir(Database::userProfile.value()).absoluteFilePath("user.db"));
	QFile importedDataFile(QDir(Database::userProfile.value()).absoluteFilePath("user.db.import"));
	if (importedDataFile.exists()) {
		dataFile.remove();
		importedDataFile.rename(dataFile.fileName());
	}
}

int main(int argc, char *argv[])
{
	// Install the error message handler
	qInstallMsgHandler(messageHandler);

	// Seed the random number generator
	qsrand(QDateTime::currentDateTime().toTime_t());
	QApplication app(argc, argv);

	QCoreApplication::setOrganizationDomain(__ORGANIZATION_NAME);
	// TODO: move all settings from "tagainijisho" to "Tagaini Jisho" for better display under OSX
	QCoreApplication::setApplicationName(__APPLICATION_NAME);
	QCoreApplication::setApplicationVersion(QUOTEMACRO(VERSION));


	// Get the default font from the settings, if set
	if (!GeneralPreferences::applicationFont.value().isEmpty()) {
		QFont font;
		font.fromString(GeneralPreferences::applicationFont.value());
		app.setFont(font);
	}

	// Load translations, if available
	QSettings settings;
	QString locale = settings.value("locale", QLocale::system().name().left(2)).toString();
	QLocale::setDefault(QLocale(locale));
	QTranslator appTranslator;
	QTranslator qtTranslator;
	if (appTranslator.load(":/i18n/tagainijisho_" + locale)) app.installTranslator(&appTranslator);
	if (qtTranslator.load(QDir(QLibraryInfo::location(QLibraryInfo::TranslationsPath)).absoluteFilePath(QString("qt_%1").arg(locale)))) {
		app.installTranslator(&qtTranslator);
	}
	checkUserProfileDirectory();

	// Register meta-types
	qRegisterMetaType<EntryPointer<Entry> >("EntryPointer<Entry>");
	qRegisterMetaType<QSqlRecord>("QSqlRecord");
	qRegisterMetaType<QSqlRecord>("QSqlError");

	// Ensure the EntriesCache is instanciated in the main thread - that way we won't have to switch
	// threads every time an Entry is deleted
	EntriesCache::init();

	// Start database thread
	// TODO check return value
	Database::startThreaded();

	// Initialize tags
	Tag::init();

	// Register core plugins
	Plugin *kanjidic2Plugin = new Kanjidic2Plugin();
	Plugin *jmdictPlugin = new JMdictPlugin();
	if (!Plugin::registerPlugin(kanjidic2Plugin))
		qFatal("Error registering kanjidic2 plugin!");
	if (!Plugin::registerPlugin(jmdictPlugin))
		qFatal("Error registering JMdict plugin!");

	// Create the main window
	MainWindow *mainWindow = new MainWindow();

	// Register GUI plugins
	Plugin *kanjidic2GUIPlugin = new Kanjidic2GUIPlugin();
	Plugin *jmdictGUIPlugin = new JMdictGUIPlugin();
	if (!Plugin::registerPlugin(jmdictGUIPlugin))
		qFatal("Error registering JMdict GUI plugin!");
	if (!Plugin::registerPlugin(kanjidic2GUIPlugin))
		qFatal("Error registering kanjidic2 GUI plugin!");

	// Show the main window and run the program
	mainWindow->show();
	int ret = app.exec();

	// Remove GUI plugins
	Plugin::removePlugin("JMdictGUI");
	Plugin::removePlugin("kanjidic2GUI");

	// Deleting the main window ensures there is no other DB query running in the
	// GUI thread
	delete mainWindow;

	// Remove core plugins
	Plugin::removePlugin("kanjidic2");
	Plugin::removePlugin("JMdict");

	// Plugins must be deleted after the main window in case the latter still uses them
	// in a background thread
	delete jmdictGUIPlugin;
	delete kanjidic2GUIPlugin;
	delete jmdictPlugin;
	delete kanjidic2Plugin;

	Tag::cleanup();

	// Stop database thread cleanly
	Database::stop();

	// Clean the entries cache
	EntriesCache::cleanup();

	return ret;
}