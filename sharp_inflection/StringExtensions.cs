using System.Linq;

namespace SharpInflection
{
    internal static class StringExtensions
    {
        public static string ToCapitalized(this string input)
        {
            return input.ToCharArray().First().ToString().ToUpper() + input.Substring(1,input.Length-1);
        }
    }
}