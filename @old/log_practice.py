#!/usr/bin

import logging

logging.basicConfig(filename='/mnt/c/Users/Wayne/tvb/tvbdemos/example.log', encoding="utf-8", level=logging.DEBUG,
#filemode="w", ##filemode not remember the messages from eariler runs
)
logging.debug("This message is a debug message")
logging.info("Output info")
logging.warning("Give out some warnings")
logging.error("Ops error")
quit()