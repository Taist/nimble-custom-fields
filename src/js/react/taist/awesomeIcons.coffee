icons =
  black:
    gear: 'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAB1UlEQVR4nO3Wz4tOYRQH8M+Mt5eUjSLKxtuU2Rs7NcIfIEkRG2HB/6DREBZ+ZKZEs+FPYSOlLCaxVNKglCzMUK7F895x577P4/5wKTXfOptznnO+33OfH/ewjubYiPfICvYOvX8lYKpEntueNsXGK+LncLzkm0ysLfuP4WwbUTCGOb+6u4f+MHZb/AtcH8Y34UHBf6WNgLsRghd4nSDP7RUWI/5GIs5XkLS18lYifgaWmqitiQwfmiRc1W33M00Vb8DTjsgf+81tSwUybEvEvmEWE8KjNCEcsu+J9TuH9SqxHYdwAQ/Fu1nGdCL/IFYSefM4ib3YnBLwOZFctEsVTczUqPExlVxnP3dXCBjUrLOKsZKAKvSl9zqPr9Sos8pb9S8oY9cfxkdQFPCpxvpTFfHTNWp8SQW2YJ9wWufF9+4r9ifyp4VbEst7hIs4LH2916CHt4liy8JpHwh7PsBl6Sv4RnjYGmEcTxIFm9ozLaal2Y7Ic7vZhPwAfnQsIMPRGFnsGu6w9n3oClubLL5htINF1RPRSzyP+O+0UXytUGBBmPVS4jLcGsb7uF/wz7Uhz3HG6Ch1JCGg/EidEMa7zjGZEDD1N8hi6AlzY5F8SRhO1vH/4SfdKTUdhV5zXgAAAABJRU5ErkJggg=='
    remove: 'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABHUlEQVR4nO3VMUoDURRA0ZMFiJUigo0L0FYXINqKoq2FLkDQBWhjkb3YuxArbcRK0EJBCCQai8mXEDTzZuYHLebC6+bNvXz4M7S0/HPWcIsn7AV3NnCPR2w1ka/jGcPRDHBYsrOJt7GdHnZyyCMRk/LxiO2qAXc/vGhaxG/yNK+Yi8o7JS+bjCiTD/GJpWgAHI2WyiIuAvIhLqvIEyeBiMhc1ZHnimgkbxqRRV43Iqs80Q3Kr2chj1y1NH3s/5U8e0QdebaIJvLGEVH5jfLb0Rf/lX/zEJB3R89Grug75qPyDl6C8kRZxAAL0QDYVRxdRB6JOK0iTxwoyiPyaRHndeTjET3VPq/HitP7wFkTeWIRqxV3lrGSQ97SMnO+APx+I7hAsLJKAAAAAElFTkSuQmCC'

get = (name, color) ->
  icons[color or 'black'][name] or ''

getDataImage = (name, color) ->
  'data:image/png;base64,' + get(name, color)

getURL = (name, color) ->
  'url("' + getDataImage(name, color) + '")'

module.exports = { get, getDataImage, getURL }
