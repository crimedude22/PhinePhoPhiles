function cb_playsound(src,evt,limits,fs,nonpssegs)
subseg = nonpssegs(limits(1):limits(2));
sound(subseg,fs);
end