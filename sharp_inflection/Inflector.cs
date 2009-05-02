using System.Linq;
using System.Text.RegularExpressions;

namespace SharpInflection
{
    public static class Inflector
    {
        private static Inflections _inflections;

        public static Inflections inflections
        {
            get
            {
                if (_inflections == null)
                {
                    _inflections = new Inflections();
                }
                return _inflections;
            }
        }

        public static string camelize(string lower_case_and_underscored_word, bool first_letter_in_uppercase)
        {
            if(first_letter_in_uppercase)
            {
                var with_expanded_paths = new Regex("/(?<letter>.)").Replace(lower_case_and_underscored_word,
                                                            m => string.Format("::{0}", m.Groups["letter"].Value.ToUpper()));
                return new Regex("(^|_)(?<letter>.)").Replace(with_expanded_paths, m => m.Groups["letter"].Value.ToUpper());
            }

            var camelized = camelize(lower_case_and_underscored_word);
            return camelized.ToCharArray().First().ToString().ToLower() + camelized.Substring(1,camelized.Length-1);
        }

        public static string camelize(string lower_case_and_underscored_word)
        {
            return camelize(lower_case_and_underscored_word, true);
        }

        public static string classify(object input)
        {
            return classify(input.ToString());
        }

        public static string classify(string input)
        {
            return "";
        }

        public static void constantize(string input)
        {
        }

        public static void dasherize(string input)
        {
        }

        public static void demodulize(string input)
        {
        }

        public static void foreign_key(string input)
        {
        }

        public static void humanize(string input)
        {
        }

        public static void ordinalize(string input)
        {
        }

        public static void singularize(string input)
        {
        }

        public static string parameterize(string @string, string sep)
        {
            return "";
        }

        public static string parameterize(string @string)
        {
            return parameterize(@string, "-");
        }

        public static void pluralize(string input)
        {
        }

        public static void tableize(string input)
        {
        }

        public static void titleize(string input)
        {
        }

        public static void underscore(string input)
        {
        }
    }
}