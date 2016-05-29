//
//	backpac.h
//
//	Cole Smith
//

#ifndef BACKPAC_H_
#define BACKPAC_H_

int read_config();
int system_checks( char** paths );
int single_backup( char** paths, int compression );
int incr_backup();
