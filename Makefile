CC = g++
UNAME = $(shell uname)

ifeq ($(UNAME),Darwin)
	OPENSSL_INCLUDE_PATH = /usr/local/opt/openssl@1.1/include
	OPENSSL_LIB_PATH = /usr/local/opt/openssl@1.1/lib
else
	OPENSSL_INCLUDE_PATH = 
	OPENSSL_LIB_PATH = 
endif
CAPSTONE_INCLUDE_PATH = 
CAPSTONE_LIB_PATH = 
KEYSTONE_INCLUDE_PATH = 
KEYSTONE_LIB_PATH = 
RAPIDJSON_INCLUDE_PATH = 

OUTPUT_DIR = ./bin/
COMMON_DIR = ./common/
PATCHER_DIR = ./navicat_patcher/
KEYGEN_DIR = ./navicat_keygen/

COMMON_HEADER = \
$(COMMON_DIR)Exception.h \
$(COMMON_DIR)ExceptionGeneric.h \
$(COMMON_DIR)ExceptionOpenssl.h \
$(COMMON_DIR)ExceptionSystem.h \
$(COMMON_DIR)ResourceTraitsOpenssl.h \
$(COMMON_DIR)ResourceWrapper.h \
$(COMMON_DIR)RSACipher.h

PATCHER_HEADER = \
$(PATCHER_DIR)CapstoneDisassembler.h \
$(PATCHER_DIR)KeystoneAssembler.h \
$(PATCHER_DIR)Elf64Interpreter.h \
$(PATCHER_DIR)ExceptionCapstone.h \
$(PATCHER_DIR)ExceptionKeystone.h \
$(PATCHER_DIR)MemoryAccess.h \
$(PATCHER_DIR)Misc.h \
$(PATCHER_DIR)PatchSolutions.h \
$(PATCHER_DIR)ResourceTraitsCapstone.h \
$(PATCHER_DIR)ResourceTraitsKeystone.h \
$(PATCHER_DIR)ResourceTraitsUnix.h

PATCHER_SOURCE = \
$(PATCHER_DIR)CapstoneDisassembler.cc \
$(PATCHER_DIR)KeystoneAssembler.cc \
$(PATCHER_DIR)Elf64Interpreter.cc \
$(PATCHER_DIR)Misc.cc \
$(PATCHER_DIR)PatchSolution.cc \
$(PATCHER_DIR)PatchSolution0.cc \
$(PATCHER_DIR)main.cc

PATCHER_BINARY = $(OUTPUT_DIR)navicat_patcher

KEYGEN_HEADER = \
$(KEYGEN_DIR)Base32.h \
$(KEYGEN_DIR)Base64.h \
$(KEYGEN_DIR)SerialNumberGenerator.h

KEYGEN_SOURCE = \
$(KEYGEN_DIR)CollectInformation.cc \
$(KEYGEN_DIR)GenerateLicense.cc \
$(KEYGEN_DIR)main.cc \
$(KEYGEN_DIR)SerialNumberGenerator.cc

KEYGEN_BINARY = $(OUTPUT_DIR)navicat_keygen

patcher: $(PATCHER_HEADER) $(PATCHER_SOURCE)
	@if [ ! -d $(OUTPUT_DIR) ]; then mkdir -p $(OUTPUT_DIR); fi
	$(CC) -std=c++17 -O2 \
-I$(COMMON_DIR) \
$(if $(OPENSSL_INCLUDE_PATH),-I$(OPENSSL_INCLUDE_PATH),) $(if $(OPENSSL_LIB_PATH),-L$(OPENSSL_LIB_PATH),) \
$(if $(CAPSTONE_INCLUDE_PATH),-I$(CAPSTONE_INCLUDE_PATH),) $(if $(CAPSTONE_LIB_PATH),-L$(CAPSTONE_LIB_PATH),) \
$(if $(KEYSTONE_INCLUDE_PATH),-I$(KEYSTONE_INCLUDE_PATH),) $(if $(KEYSTONE_LIB_PATH),-L$(KEYSTONE_LIB_PATH),) \
$(PATCHER_SOURCE) -o $(PATCHER_BINARY) -lcrypto -lcapstone -lkeystone
	@echo

keygen: $(KEYGEM_HEADER) $(KEYGEN_SOURCE)
	@if [ ! -d $(OUTPUT_DIR) ]; then mkdir -p $(OUTPUT_DIR); fi
	$(CC) -std=c++17 -O2 \
-I$(COMMON_DIR) \
$(if $(OPENSSL_INCLUDE_PATH),-I$(OPENSSL_INCLUDE_PATH),) $(if $(OPENSSL_LIB_PATH),-L$(OPENSSL_LIB_PATH),) \
$(if $(RAPIDJSON_INCLUDE_PATH),-I$(RAPIDJSON_INCLUDE_PATH),) \
$(KEYGEN_SOURCE) -o $(KEYGEN_BINARY) -lcrypto

all: patcher keygen
	@echo 'Done.'

.PHONY: all

clean:
ifeq ($(wildcard $(PATCHER_BINARY)), $(PATCHER_BINARY))
	rm $(PATCHER_BINARY)
endif

ifeq ($(wildcard $(KEYGEN_BINARY)), $(KEYGEN_BINARY))
	rm $(KEYGEN_BINARY)
endif

