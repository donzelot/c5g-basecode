# if you don't want Quartus in your PATH (I don't), try putting
# "Q=/storage/bin/altera/13.1/quartus/bin/quartus_" (or whatever) in
# ~/.quartus_config.mk

PROJ=base
VLOGS=demo.v

-include $(HOME)/.quartus_config.mk
Q ?= quartus_

QPARAMS=--read_settings_files=off --write_settings_files=off $(PROJ)

all: $(PROJ).svf sta

clean:
	rm -rf db hc_output output_files incremental_db $(PROJ).svf $(PROJ).qpf c5_pin_model_dump.txt

map:
	$(Q)map $(QPARAMS) --read_settings_files=on $(addprefix --source=,$(VLOGS))

fit: map
	$(Q)fit $(QPARAMS)

asm: fit
	$(Q)asm $(QPARAMS)

sta: fit
	$(Q)sta $(PROJ)

eda: fit
	$(Q)eda $(QPARAMS)

output_files/$(PROJ).sof: asm

$(PROJ).svf: output_files/$(PROJ).sof
	$(Q)cpf -c -q 33MHz -g 3.3 -n p $< $@

