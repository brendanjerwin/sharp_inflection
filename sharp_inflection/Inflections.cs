namespace SharpInflection
{
    public class Inflections
    {
        public string[] plurals()
        {
            return new string[0];
        }

        public string[] singulars()
        {
            return new string[0];
        }

        public string[] uncountables()
        {
            return new string[0];
        }

        public string[] humans()
        {
            return new string[0];
        }

        public void clear()
        {
            clear("all");
        }

        public void clear(object scope)
        {}
    }
}