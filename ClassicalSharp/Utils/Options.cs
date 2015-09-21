﻿using System;
using System.Collections.Generic;
using System.IO;

namespace ClassicalSharp {
	
	public static class Options {
		
		static Dictionary<string, string> OptionsSet = new Dictionary<string, string>();
		
		public static string Get( string key ) {
			string value;
			return OptionsSet.TryGetValue( key, out value ) ? value : null;
		}
		
		public static void Set( string key, string value ) {
			OptionsSet[key] = value;
		}
		
		public const string OptionsFile = "options.txt";
		
		public static void Load() {
			try {
				using( StreamReader reader = new StreamReader( OptionsFile, false ) )
					LoadFrom( reader );
			} catch( FileNotFoundException ) {
				
			}
		}
		
		static void LoadFrom( StreamReader reader ) {
			string line;
			while( ( line = reader.ReadLine() ) != null ) {
				if( line.Length == 0 && line[0] == '#' ) continue;
				
				int separatorIndex = line.IndexOf( '=' );
				if( separatorIndex <= 0 ) continue;
				string key = line.Substring( 0, separatorIndex );
				
				separatorIndex++;
				if( separatorIndex == line.Length ) continue;
				string value = line.Substring( separatorIndex, line.Length - separatorIndex );
				OptionsSet[key] = value;
			}
		}
		
		public static void Save() {
			using( StreamWriter writer = new StreamWriter( OptionsFile ) ) {
				foreach( KeyValuePair<string, string> pair in OptionsSet ) {
					writer.Write( pair.Key );
					writer.Write( '=' );
					writer.Write( pair.Value );
					writer.WriteLine();
				}
			}
		}
	}
}
