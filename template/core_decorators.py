import shared_variables
import wrapt

# define decorators
def subset_returned_generator(wrapped=None, n_max = 2):
    if wrapped is None:
        return functools.partial(subset_returned_generator,
                n_max=n_max)

    @wrapt.decorator(enabled = shared_variables.enabled_wrapt_decorators)
    def wrapper(wrapped, instance, args, kwargs):
        return (x for _, x in zip(range(n_max), wrapped(*args, **kwargs) ))

    return wrapper(wrapped)
